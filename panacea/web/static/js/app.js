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
    const response = await fetch(this.action, {
      method: 'POST',
      body: new FormData(this),
      credentials: 'same-origin',
      headers: new Headers({authorization: apiAccessToken})
    });

    if (response.ok) {
      renderSuccess(await response.json());
    } else {
      renderError(await response.json());
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

const renderSuccess = data => {
  const drugsResultMessage = document.getElementById('success-result-message');
  const ddisResultMessage = document.getElementById('success-ddis-message');

  drugsResultMessage.innerHTML = JSON.stringify(data.drugs);
  ddisResultMessage.innerHTML = JSON.stringify(data.ddis);

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
});
