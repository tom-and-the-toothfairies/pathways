import "babel-polyfill";
import "phoenix_html";

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
      const data = await drugsResponse.json();
      const drugs = data.drugs;
      if (drugs.length > 0){
        displayDrugs(drugs);

        const urisResponse = await fetch("/api/uris", {
          method: 'POST',
          body: JSON.stringify({labels: drugs}),
          credentials: 'same-origin',
          headers: defaultHeaders
        });

        if (urisResponse.ok) {
          const data = await urisResponse.json();
          const uris = Object.keys(data.uris.found);
          const unidentifiedDrugs = Object.values(data.uris.not_found);
          if (unidentifiedDrugs.length > 0){
            displayUnidentifiedDrugs(unidentifiedDrugs);
          }
          if (uris.length >= 2){
            const ddisResponse = await fetch("/api/ddis", {
              method: 'POST',
              body: JSON.stringify({drugs: uris}),
              credentials: 'same-origin',
              headers: defaultHeaders
            });

            if (ddisResponse.ok) {
              const data = await ddisResponse.json();
              const ddis = data.ddis;
              displayDdis(ddis);
            } else {
              displayError(await ddisResponse.json());
            }
          }
          else {
            // TODO: ddis require more than one drug by definition
            console.log("less than two identified drugs, no ddis")
          }
        } else {
          displayError(await urisResponse.json());
        }
      }
      else {
        displayError({"message": "No drugs found"});
      }
    } else {
      displayError(await drugsResponse.json());
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

const hideResults = () => {
  drugsPanel.classList.add('hidden');
  unidentifiedDrugsPanel.classList.add('hidden');
  ddisPanel.classList.add('hidden');
  errorPanel.classList.add('hidden');
}

const displayDrugs = drugs => {
  const drugsTextElement = document.getElementById('drugs-text');
  drugsTextElement.innerHTML = JSON.stringify(drugs);

  drugsPanel.classList.remove('hidden');
}

const displayUnidentifiedDrugs = drugs => {
  const unidentifiedDrugsTextElement = document.getElementById('unidentified-drugs-text');
  unidentifiedDrugsTextElement.innerHTML = JSON.stringify(drugs);

  unidentifiedDrugsPanel.classList.remove('hidden');
}

const displayDdis = ddis => {
  const ddisTextElement = document.getElementById('ddis-text');
  ddisTextElement.innerHTML = JSON.stringify(ddis);

  ddisPanel.classList.remove('hidden');
}

const displayError = error => {
  const errorTextElement = document.getElementById('error-text');
  errorTextElement.innerHTML = JSON.stringify(error);

  errorPanel.classList.remove('hidden');
}

const formElement = document.getElementById('file-form');
const loadingElement = document.getElementById('loading-container');

const hideFileForm = () => {
  formElement.classList.add('hidden');
  loadingElement.classList.remove('hidden');
}

const restoreFileForm = () => {
  formElement.classList.remove('hidden');
  loadingElement.classList.add('hidden');
}

// to make the file input pretty take the filename from the form
// and place it in a disabled input box right beside it :art:
const filenameDisplayElement = document.getElementById('filename-display');
const fileInputElement = document.getElementById('file-input');
fileInputElement.addEventListener('change', function(e) {
  filenameDisplayElement.value = this.files[0].name;
  hideResults();
});
