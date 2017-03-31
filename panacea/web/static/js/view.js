import * as CodeBlock from './code-block';
import * as Util from './util';

const drugsPanel              = document.getElementById('drugs-panel');
const unidentifiedDrugsPanel  = document.getElementById('unidentified-drugs-panel');
const ddisPanel               = document.getElementById('ddis-panel');
const errorPanel              = document.getElementById('error-panel');
const unnamedPanel            = document.getElementById('unnamed-panel');
const clashesPanel            = document.getElementById('clashes-panel');
const pmlDownloadContainer    = document.getElementById('pml-download-container');
const pmlDownloadAnchor       = document.getElementById('pml-download-anchor');
export const fileForm         = document.getElementById('file-form');
export const fileInput        = document.getElementById('file-input');

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
  const drugsHTML = drugs.map(d => `<li><a target="_blank" href="${d.uri}">${d.label}</a></li>`).join('');
  drugsTextElement.innerHTML = `<p>${preamble}</p><ul>${drugsHTML}</ul>`;

  showElement(drugsPanel);
};

const displayWarnings = (container, preambleText, warnings, pml) => {
  container.innerHTML = '';

  const preamble = document.createElement('p');
  preamble.innerHTML = preambleText;
  container.appendChild(preamble);

  for (const warning of warnings) {
    const wrapper = Util.createElementWithClass('div', 'warning-wrapper');

    for (const member of warning) {
      const details = document.createElement('strong');
      details.innerHTML = `${member.identifier} on line ${member.line}`;
      wrapper.appendChild(details);

      const codeBlock = CodeBlock.generate(pml, member.line);
      wrapper.appendChild(codeBlock);
    }

    container.appendChild(wrapper);
  }
};

export const displayUnnamed = (unnamed, pmlLines) => {
  if (unnamed.length > 0){
    const container = document.getElementById('unnamed-text');
    const preamble = 'I found the following unnamed PML constructs:';
    const warnings = unnamed.map(({type, line}) => {
      return [{line, identifier: type}];
    });

    displayWarnings(container, preamble, warnings, pmlLines);
    showElement(unnamedPanel);
  } else {
    // no unnamed properties to display
  }
};

export const displayClashes = (clashes, pmlLines) => {
  if (clashes.length > 0) {
    const container = document.getElementById('clashes-text');
    const preamble = 'I found the following PML construct name clashes:';
    const warnings = clashes.map(({occurrences, name}) => {
      return occurrences
        .sort((a, b) => a.line - b.line)
        .map(({type, line}) => {
          return {line, identifier: `${type} ${name}`};
        });
    });

    displayWarnings(container, preamble, warnings, pmlLines);
    showElement(clashesPanel);
  } else {
    // no clashes to display
  }
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
  if (drugs.length > 0) {
    const unidentifiedDrugsTextElement = document.getElementById('unidentified-drugs-text');
    const preamble = 'I did not recognise the following drugs:';
    const drugsHTML = drugs.map(x => `<li>${x}</li>`).join('');
    unidentifiedDrugsTextElement.innerHTML = `<p>${preamble}</p><ul>${drugsHTML}</ul>`;

    showElement(unidentifiedDrugsPanel);
  }
};

export const displayDdis = (ddis) => {
  if (ddis.length > 0) {
    const ddisTextElement = document.getElementById('ddis-text');
    const preamble = 'I have identified interactions between the following drugs:';
    const ddisHTML = ddis.map(({drug_a, drug_b}) => {
      const labelA = drug_a.label;
      const labelB = drug_b.label;

      return `<li><strong>${labelA}</strong> and <strong>${labelB}</strong></li>`;
    }).join('');

    ddisTextElement.innerHTML = `<p>${preamble}</p><ul>${ddisHTML}</ul>`;
    showElement(ddisPanel);
  } else {
    displayNoDdis();
  }
};

export const displayNoDdis = () => {
  const ddisTextElement = document.getElementById('ddis-text');
  ddisTextElement.innerHTML = 'I have not identified any interactions between the drugs in this file.';
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
  const title = 'Network error';
  const detail = `<h5>Something went wrong</h5><code>${error}<code>`;
  displayError({title, detail});
};

export const displayNoDrugsError = () => {
  const title = 'Pathway error';
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
fileInput.addEventListener('change', function() {
  filenameDisplayElement.value = this.files[0].name;
  hideResults();
  hideDownloadButton();
});
