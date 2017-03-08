import "babel-polyfill";
import "phoenix_html";

const apiAccessToken = document.getElementById('api-access-token').content;

document.getElementById('file-form').addEventListener('submit', e => {
  e.preventDefault();
  submitFile.bind(e.target)();
});

async function submitFile() {
  hideFileForm();
  hideResults();
  try {
    const drugs_response = await fetch(this.action, {
      method: 'POST',
      body: new FormData(this),
      credentials: 'same-origin',
      headers: new Headers({authorization: apiAccessToken})
    });

    if (drugs_response.ok) {
      const data = await drugs_response.json();
      const drugs = data.drugs;
      displayDrugs(drugs);

      const uris_response = await fetch("/api/uris", {
        method: 'POST',
        body: JSON.stringify({labels: drugs}),
        credentials: 'same-origin',
        headers: new Headers({authorization: apiAccessToken, "Content-Type": "application/json"})
      });

      if (uris_response.ok) {
        const data = await uris_response.json();
        const uris = Object.keys(data.uris.found);

        const ddis_response = await fetch("/api/ddis", {
          method: 'POST',
          body: JSON.stringify({drugs: uris}),
          credentials: 'same-origin',
          headers: new Headers({authorization: apiAccessToken, "Content-Type": "application/json"})
        });

        if (ddis_response.ok) {
          const data = await ddis_response.json();
          const ddis = data.ddis;
          displayDdis(ddis);
        } else {
        displayError(await ddis_response.json());
        }
      } else {
        displayError(await uris_response.json());
      }
    } else {
      displayError(await drugs_response.json());
    }
    this.reset();
  } catch (err) {
    console.log(err);
  }
  restoreFileForm();
}

const drugsPanel = document.getElementById('drugs-panel');
const ddisPanel = document.getElementById('ddis-panel');
const errorPanel = document.getElementById('error-panel');

const hideResults = () => {
  drugsPanel.classList.add('hidden');
  ddisPanel.classList.add('hidden');
  errorPanel.classList.add('hidden');
}

const displayDrugs = drugs => {
  const drugsTextElement = document.getElementById('drugs-text');
  drugsTextElement.innerHTML = JSON.stringify(drugs);

  errorPanel.classList.add('hidden');
  drugsPanel.classList.remove('hidden');
  ddisPanel.classList.add('hidden');
}

const displayDdis = ddis => {
  const ddisTextElement = document.getElementById('ddis-text');
  ddisTextElement.innerHTML = JSON.stringify(ddis);

  errorPanel.classList.add('hidden');
  drugsPanel.classList.remove('hidden');
  ddisPanel.classList.remove('hidden');
}

const displayError = error => {
  const errorTextElement = document.getElementById('error-text');
  errorTextElement.innerHTML = JSON.stringify(error);

  errorPanel.classList.remove('hidden');
  drugsPanel.classList.add('hidden');
  ddisPanel.classList.add('hidden');
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
