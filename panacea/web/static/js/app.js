import "babel-polyfill";
import "phoenix_html";
import "whatwg-fetch";

const apiAccessToken = document.getElementById('api-access-token').content;
const defaultHeaders = new Headers({
  "Authorization": apiAccessToken,
  "Content-Type": "application/json",
  "Accept": "application/json, text/plain, */*"
});

document.getElementById('file-form').addEventListener('submit', e => {
  e.preventDefault();
  submitFile.bind(e.target)();
});

async function submitFile() {
  hideFileForm();
  hideResults();
  try {
    const drugsResponse = await fetch(this.action, {
      method: 'POST',
      body: new FormData(this),
      credentials: 'same-origin',
      headers: new Headers({authorization: apiAccessToken})
    });

    if (drugsResponse.ok) {
      const {drugs} = await drugsResponse.json();
      const labels = drugs.map(x => x.label);

      if (labels.length > 0) {
        displayDrugs(labels);

        const urisResponse = await fetch('/api/uris', {
          method: 'POST',
          body: JSON.stringify({labels: labels}),
          credentials: 'same-origin',
          headers: defaultHeaders
        });

        if (urisResponse.ok) {
          const {uris: {found, not_found: unidentifiedDrugs}} = await urisResponse.json();
          const uris = found.map(x => x.uri);

          if (unidentifiedDrugs.length > 0) {
            displayUnidentifiedDrugs(unidentifiedDrugs);
          }

          if (uris.length >= 2) {
            const ddisResponse = await fetch('/api/ddis', {
              method: 'POST',
              body: JSON.stringify({drugs: uris}),
              credentials: 'same-origin',
              headers: defaultHeaders
            });

            if (ddisResponse.ok) {
              const {ddis} = await ddisResponse.json();
              displayDdis(ddis);
            } else {
              const {error} = await ddisResponse.json();
              displayError(error);
            }
          } else {
            console.log("by definition ddis require more than one drug")
          }
        } else {
          const {error} = await urisResponse.json();
          displayError(error);
        }
      } else {
        displayError({title: "Pathway error", detail: "No drugs found"});
      }
    } else {
      const {error} = await drugsResponse.json();
      displayError(error);
    }
    this.reset();
  } catch (err) {
    console.log(err);
  }
  restoreFileForm();
}

const drugsPanel = document.getElementById('drugs-panel');
const unidentifiedDrugsPanel = document.getElementById('unidentified-drugs-panel');
const ddisPanel = document.getElementById('ddis-panel');
const errorPanel = document.getElementById('error-panel');

const hideElement = element => {
  element.classList.add('hidden');
};

const showElement = element => {
  element.classList.remove('hidden');
};

const hideResults = () => {
  hideElement(drugsPanel);
  hideElement(unidentifiedDrugsPanel);
  hideElement(ddisPanel);
  hideElement(errorPanel);
};

const displayDrugs = drugs => {
  const drugsTextElement = document.getElementById('drugs-text');
  drugsTextElement.innerHTML = JSON.stringify(drugs);

  showElement(drugsPanel);
};

const displayUnidentifiedDrugs = drugs => {
  const unidentifiedDrugsTextElement = document.getElementById('unidentified-drugs-text');
  unidentifiedDrugsTextElement.innerHTML = JSON.stringify(drugs);

  showElement(unidentifiedDrugsPanel);
};

const displayDdis = ddis => {
  const ddisTextElement = document.getElementById('ddis-text');
  ddisTextElement.innerHTML = JSON.stringify(ddis);

  showElement(ddisPanel);
};

const displayError = error => {
  const errorTitleElement = document.getElementById('error-title');
  const errorTextElement = document.getElementById('error-text');

  errorTitleElement.innerHTML = error.title;
  errorTextElement.innerHTML = error.detail;

  showElement(errorPanel);
};

const formElement = document.getElementById('file-form');
const loadingElement = document.getElementById('loading-container');

const hideFileForm = () => {
  hideElement(formElement);
  showElement(loadingElement);
};

const restoreFileForm = () => {
  showElement(formElement);
  hideElement(loadingElement);
};

// to make the file input pretty take the filename from the form
// and place it in a disabled input box right beside it :art:
const filenameDisplayElement = document.getElementById('filename-display');
const fileInputElement = document.getElementById('file-input');
fileInputElement.addEventListener('change', function(e) {
  filenameDisplayElement.value = this.files[0].name;
  hideResults();
});
