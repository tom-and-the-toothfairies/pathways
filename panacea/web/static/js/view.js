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

export const hideResults = () => {
  hideElement(drugsPanel);
  hideElement(unidentifiedDrugsPanel);
  hideElement(ddisPanel);
  hideElement(errorPanel);
};

export const displayDrugs = drugs => {
  const drugsTextElement = document.getElementById('drugs-text');
  drugsTextElement.innerHTML = JSON.stringify(drugs);

  showElement(drugsPanel);
};

export const displayUnidentifiedDrugs = drugs => {
  const unidentifiedDrugsTextElement = document.getElementById('unidentified-drugs-text');
  unidentifiedDrugsTextElement.innerHTML = JSON.stringify(drugs);

  showElement(unidentifiedDrugsPanel);
};

export const displayDdis = ddis => {
  const ddisTextElement = document.getElementById('ddis-text');
  ddisTextElement.innerHTML = JSON.stringify(ddis);

  showElement(ddisPanel);
};

export const displayError = error => {
  const errorTitleElement = document.getElementById('error-title');
  const errorTextElement = document.getElementById('error-text');

  errorTitleElement.innerHTML = error.title;
  errorTextElement.innerHTML = error.detail;

  showElement(errorPanel);
};

const formElement = document.getElementById('file-form');
const loadingElement = document.getElementById('loading-container');

export const hideFileForm = () => {
  hideElement(formElement);
  showElement(loadingElement);
};

export const restoreFileForm = () => {
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
