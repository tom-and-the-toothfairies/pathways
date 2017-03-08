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

      const uris_response = await fetch("/api/uris", {
        method: 'POST',
        body: JSON.stringify({labels: drugs}),
        credentials: 'same-origin',
        headers: new Headers({authorization: apiAccessToken, "Content-Type": "application/json"})
      });

      if (uris_response.ok) {
        const data = await uris_response.json();
        const uris = Object.keys(data.uris.found);
        console.log(uris);

        const ddis_response = await fetch("/api/ddis", {
          method: 'POST',
          body: JSON.stringify({drugs: uris}),
          credentials: 'same-origin',
          headers: new Headers({authorization: apiAccessToken, "Content-Type": "application/json"})
        });

        if (ddis_response.ok) {
          const data = await ddis_response.json();
          const ddis = data.ddis;
          renderSuccess(drugs, ddis);
        } else {
        renderError(await ddis_response.json());
        }
      } else {
        renderError(await uris_response.json());
      }
    } else {
      renderError(await drugs_response.json());
    }
    this.reset();
  } catch (err) {
    console.log(err);
  }
  restoreFileForm();
}

const successElement = document.getElementById('success');
const errorElement = document.getElementById('error');

const hideResults = () => {
  errorElement.classList.add('hidden');
  successElement.classList.add('hidden');
}

const renderSuccess = (drugs, ddis) => {
  const drugsResultMessage = document.getElementById('success-result-message');
  const ddisResultMessage = document.getElementById('success-ddis-message');

  drugsResultMessage.innerHTML = JSON.stringify(drugs);
  ddisResultMessage.innerHTML = JSON.stringify(ddis);

  errorElement.classList.add('hidden');
  successElement.classList.remove('hidden');
};

const renderError = data => {
  const errorResultMessage = document.getElementById('error-result-message');
  errorResultMessage.innerHTML = data.message;

  errorElement.classList.remove('hidden');
  successElement.classList.add('hidden');
};

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
