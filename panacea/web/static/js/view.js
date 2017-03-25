const drugsPanel              = document.getElementById('drugs-panel');
const unidentifiedDrugsPanel  = document.getElementById('unidentified-drugs-panel');
const ddisPanel               = document.getElementById('ddis-panel');
const errorPanel              = document.getElementById('error-panel');
const unnamedPanel            = document.getElementById('unnamed-panel');
const clashesPanel            = document.getElementById('clashes-panel');
const pmlDownloadContainer    = document.getElementById('pml-download-container');
const pmlDownloadAnchor       = document.getElementById('pml-download-anchor');
export const fileInputElement = document.getElementById('file-input');

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
  hideElement(unnamedPanel);
  hideElement(clashesPanel);
  hideElement(errorPanel);
};

export const displayDrugs = drugs => {
  const drugsTextElement = document.getElementById('drugs-text');
  const preamble = 'I recognised the following drugs:';
  const drugsHTML = drugs.map(x => `<li>${x}</li>`).join('');
  drugsTextElement.innerHTML = `<p>${preamble}</p><ul>${drugsHTML}</ul>`;

  showElement(drugsPanel);
};

export const displayUnnamed = (unnamed, pmlLines) => {
  const unnamedTextElement = document.getElementById('unnamed-text');
  unnamedTextElement.innerHTML = '';

  const preamble = document.createElement('P');
  preamble.innerHTML = 'I found the following unnamed PML constructs:';
  unnamedTextElement.appendChild(preamble);

  for (const construct of unnamed) {
    const details = document.createElement('STRONG');
    details.innerHTML = `Unnamed ${construct.type} found on line ${construct.line}:`;
    unnamedTextElement.appendChild(details);
    unnamedTextElement.appendChild(generateErrorHighlight(pmlLines, construct.line));
  }

  showElement(unnamedPanel);
};

export const displayClashes = (clashes, pmlLines) => {
  const clashesTextElement = document.getElementById('clashes-text');
  clashesTextElement.innerHTML = '';

  const preamble = document.createElement('P');
  preamble.innerHTML = 'I found the following PML construct name clashes:';
  clashesTextElement.appendChild(preamble);

  for (const clash of clashes) {
    const sorted = clash.occurrences.sort((a, b) => a.line - b.line);

    const wrapper = createElementWithClass('DIV', 'clash-wrapper');

    for (const occurrence of sorted) {
      const details = document.createElement('STRONG');
      details.innerHTML = `${occurrence.type} ${clash.name} found on line ${occurrence.line}:`;
      wrapper.appendChild(details);
      wrapper.appendChild(generateErrorHighlight(pmlLines, occurrence.line));
    }

    clashesTextElement.appendChild(wrapper);
  }

  showElement(clashesPanel);
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

const generateErrorHighlight = (lines, errorLine, numContextLines = 2) => {
  const errorlineIndex = errorLine - 1;

  const startIndex = Math.max(0, errorlineIndex - numContextLines);
  const endIndex = Math.min(lines.length-1, errorlineIndex + numContextLines);
  const displayLines = lines.slice(startIndex, endIndex + 1); // slice extracts up to but not including end

  const codeBlockElement = createElementWithClass('PRE','code-block');

  displayLines.forEach((lineContents, currentIndex) => {
    const currentLineIndex = startIndex + currentIndex;
    const currentLineNum = currentLineIndex + 1;

    const lineContainer = createElementWithClass('SPAN', 'line');
    if (currentLineIndex === errorlineIndex) {
      lineContainer.classList.add('highlighted');
    }

    const lineNumberSpan = createElementWithClass('SPAN', 'ln');
    lineNumberSpan.innerHTML = currentLineNum;

    const lineContentSpan = createElementWithClass('SPAN', 'code');
    lineContentSpan.innerHTML = lineContents;

    lineContainer.appendChild(lineNumberSpan);
    lineContainer.appendChild(lineContentSpan);
    codeBlockElement.appendChild(lineContainer);
  });

  return codeBlockElement;
};

const createElementWithClass = (elementName, className) => {
  const element = document.createElement(elementName);
  element.classList.add(className);
  return element;
}

// to make the file input pretty take the filename from the form
// and place it in a disabled input box right beside it :art:
const filenameDisplayElement = document.getElementById('filename-display');
fileInputElement.addEventListener('change', function(e) {
  filenameDisplayElement.value = this.files[0].name;
  hideResults();
  hideDownloadButton();
});
