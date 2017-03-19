const drugsPanel = document.getElementById('drugs-panel');
const unidentifiedDrugsPanel = document.getElementById('unidentified-drugs-panel');
const ddisPanel = document.getElementById('ddis-panel');
const errorPanel = document.getElementById('error-panel');
const pmlDownloadContainer = document.getElementById('pml-download-container');
const pmlDownloadAnchor = document.getElementById('pml-download-anchor');

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
  const preamble = 'I recognised the following drugs:';
  const drugsHTML = drugs.map(x => `<li>${x}</li>`).join('');
  drugsTextElement.innerHTML = `<p>${preamble}</p><ul>${drugsHTML}</ul>`;

  showElement(drugsPanel);
};

const displayDownloadButton = () => {
  showElement(pmlDownloadContainer);
};

export const preparePMLDownloadButton = href => {
  pmlDownloadAnchor.setAttribute('href', href);
  displayDownloadButton();
};

const hideDownloadButton = () => {
  hideElement(pmlDownloadContainer);
};

export const displayUnidentifiedDrugs = drugs => {
  const unidentifiedDrugsTextElement = document.getElementById('unidentified-drugs-text');
  const preamble = 'I did not recognise the following drugs:';
  const drugsHTML = drugs.map(x => `<li>${x}</li>`).join('');
  unidentifiedDrugsTextElement.innerHTML = `<p>${preamble}</p><ul>${drugsHTML}</ul>`;

  showElement(unidentifiedDrugsPanel);
};

export const displayDdis = (ddis, urisToLabels) => {
  const ddisTextElement = document.getElementById('ddis-text');

  if (ddis.length > 0) {
    const preamble = 'I have identified interactions between the following drugs:';
    const ddisHTML = ddis.map(({drug_a: uriA, drug_b: uriB}) => {
      const drugA = urisToLabels[uriA];
      const drugB = urisToLabels[uriB];

      return `<li><strong>${drugA}</strong> and <strong>${drugB}</strong></li>`;
    }).join('');

    ddisTextElement.innerHTML = `<p>${preamble}</p><ul>${ddisHTML}</ul>`;
  } else {
    ddisTextElement.innerHTML = 'I have not identified any interactions between the drugs in this file.';
  }
  showElement(ddisPanel);
};

export const displayError = error => {
  const errorTitleElement = document.getElementById('error-title');
  const errorTextElement = document.getElementById('error-text');

  errorTitleElement.innerHTML = error.title;
  errorTextElement.innerHTML = error.detail;

  showElement(errorPanel);
};

export const displayNetworkError = error => {
  const title = "Network error";
  const detail = `<h5>Something went wrong</h5><code>${error}<code>`;
  displayError({title, detail});
};

export const displayNoDrugsError = () => {
  const title = "Pathway error";
  const detail = `<h5>No drugs were found in the given file.
You can specify drugs in PML like this:</h5>
<code>requires { drug { "paracetamol" } }</code>`;
  displayError({title, detail});
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
  hideDownloadButton();
});
