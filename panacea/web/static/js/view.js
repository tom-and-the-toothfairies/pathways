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
const resultsContainer        = document.getElementById('results-container');
export const fileForm         = document.getElementById('file-form');
export const fileInput        = document.getElementById('file-input');

const hideElement = element => {
  element.classList.add('hidden');
};

const showElement = element => {
  element.classList.remove('hidden');
};

const showResults = () => {
  showElement(resultsContainer);
};

export const hideResults = () => {
  hideElement(drugsPanel);
  hideElement(unidentifiedDrugsPanel);
  hideElement(ddisPanel);
  hideElement(unnamedPanel);
  hideElement(clashesPanel);
  hideElement(errorPanel);
  hideElement(resultsContainer);
  resetTabs();
};

export const displayDrugs = drugs => {
  if (drugs.length > 0) {
    const drugsTextElement = document.getElementById('drugs-text');
    const preambleElement = document.createElement('p');
    const drugsList = document.createElement('ul');
    const preamble = 'I recognised the following drugs:';

    preambleElement.innerHTML = preamble;
    drugsTextElement.innerHTML = '';

    for (const drug of drugs) {
      const drugListElement = document.createElement('li');
      drugListElement.innerHTML = drug.label;
      drugsList.appendChild(drugListElement);
    }

    drugsTextElement.appendChild(preambleElement);
    drugsTextElement.appendChild(drugsList);

    showElement(drugsPanel);
    showResults();
  }
};

const resetTabs = () => {
  document.getElementById('warnings-badge').innerHTML = '';
  document.getElementById('errors-badge').innerHTML = '';
  document.getElementById('analysis-tab').click();
};

const updateWarningsBadge = warnings => {
  const warningsBadge = document.getElementById('warnings-badge');
  const currentWarningNumber = parseInt(warningsBadge.innerHTML);
  let newWarningNumber = null;
  if (!isNaN(currentWarningNumber)) {
    newWarningNumber = currentWarningNumber + warnings.length;
  } else {
    newWarningNumber = warnings.length;
  }
  warningsBadge.innerHTML = newWarningNumber;
};

const displayWarnings = (container, preambleText, warnings, pml) => {
  container.innerHTML = '';

  updateWarningsBadge(warnings);

  const preamble = document.createElement('p');
  preamble.innerHTML = preambleText;
  container.appendChild(preamble);

  for (const warning of warnings) {
    const wrapper = Util.createElementWithClass('div', 'wrapper');
    wrapper.classList.add('warning');

    for (const member of warning) {
      const details = document.createElement('strong');
      details.innerHTML = `${member.identifier} on line ${member.line}`;
      wrapper.appendChild(details);

      const codeBlock = CodeBlock.generate(pml, member.line);
      wrapper.appendChild(codeBlock);
    }

    container.appendChild(wrapper);
  }

  showResults();
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
    updateWarningsBadge(drugs);
    showResults();
  }
};

export const displayDdis = (ddis) => {
  if (ddis.length > 0) {
    const ddisTextElement = document.getElementById('ddis-text');
    const preambleElement = document.createElement('p');
    const ddisContainer = document.createElement('div');
    const preamble = 'I have identified the following interactions:';

    preambleElement.innerHTML = preamble;
    ddisTextElement.innerHTML = '';

    for (const ddi of ddis) {
      const ddiContainer = generateDdiElement(ddi);
      ddisContainer.appendChild(ddiContainer);
    }

    ddisTextElement.appendChild(preambleElement);
    ddisTextElement.appendChild(ddisContainer);

    showElement(ddisPanel);
  } else {
    displayNoDdis();
  }
};

const formatDdiCategoryAtom = category => {
  let formattedCategory = category.replace('_',' ');
  if (formattedCategory === 'alternative') {
    formattedCategory += ' non-DDI';
  }
  return formattedCategory;
};

const formatDdiConstructs = constructs => {
  return constructs.map(construct => {
    return `${construct.type} on line ${construct.line}`;
  }).join(', ');
};

const generateDdiElement = ddi => {
  const ddiContainer = document.createElement('div');
  let containerClass = null;
  if (ddi.harmful) {
    if (ddi.category === 'alternative') {
      containerClass = 'warning';
    } else {
      containerClass = 'danger';
    }
  } else {
    containerClass = 'success';
  }
  ddiContainer.classList.add('wrapper', containerClass);

  const interactionNameElement = Util.createElementWithClass('h5', 'ddi-title');
  interactionNameElement.innerHTML = ddi.label;
  const drugsInvolvedText = `${ddi.drug_a.label} on line ${ddi.drug_a.line} and ${ddi.drug_b.label} on line ${ddi.drug_b.line}`;
  const drugInfoElement = generateDdiInfoSnippet('Drugs Involved', drugsInvolvedText);
  const harmfulElement = generateDdiInfoSnippet('Disposition', ddi.harmful ? 'Harmful' : 'Not Harmful');
  const categoryElement = generateDdiInfoSnippet('Category', formatDdiCategoryAtom(ddi.category));
  const constructsElement = generateDdiInfoSnippet('Enclosing Constructs', formatDdiConstructs(ddi.enclosing_constructs));
  const spacingElement = generateDdiInfoSnippet('Interaction Window', `${ddi.spacing} days`);

  ddiContainer.appendChild(interactionNameElement);
  ddiContainer.appendChild(drugInfoElement);
  ddiContainer.appendChild(harmfulElement);
  ddiContainer.appendChild(categoryElement);
  ddiContainer.appendChild(constructsElement);
  ddiContainer.appendChild(spacingElement);

  return ddiContainer;
};

const generateDdiInfoSnippet = (labelText, infoText) => {
  const container = Util.createElementWithClass('div', 'ddi-info');
  const label = Util.createElementWithClass('span', 'ddi-info-label');
  const info = Util.createElementWithClass('span', 'ddi-info-text');

  label.innerHTML = labelText;
  info.innerHTML = infoText;
  container.appendChild(label);
  container.appendChild(info);

  return container;
};

export const displayNoDdis = () => {
  const ddisTextElement = document.getElementById('ddis-text');
  ddisTextElement.innerHTML = 'I have not identified any interactions between the drugs in this file.';
  showElement(ddisPanel);
};

export const displayError = (error, pml) => {
  const errorTitleElement = document.getElementById('error-title');
  const errorTextElement = document.getElementById('error-text');
  const errorsBadge = document.getElementById('errors-badge');
  const errorsTab = document.getElementById('errors-tab');

  errorsBadge.innerHTML = '1';
  errorsTab.click();
  errorTitleElement.innerHTML = error.title;
  errorTextElement.innerHTML = error.detail;
  if (error.meta && error.meta.line) {
    const codeBlock = CodeBlock.generate(pml, error.meta.line);
    errorTextElement.appendChild(codeBlock);
  }

  showElement(errorPanel);
  showResults();
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
