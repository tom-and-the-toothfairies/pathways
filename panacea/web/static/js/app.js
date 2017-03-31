import 'babel-polyfill';
import 'bootstrap';
import 'whatwg-fetch';
import * as Request from './request';
import * as View from './view';

document.getElementById('file-form').addEventListener('submit', e => {
  e.preventDefault();
  submitFile.bind(e.target)();
});

async function submitFile() {
  View.hideFileForm();
  View.hideResults();
  try {
    await handleDrugsResponse(await Request.drugs(new FormData(this)));
  } catch (e) {
    View.displayNetworkError(e);
  }
  this.reset();
  View.restoreFileForm();
}

async function handleResponse(response, handle) {
  if (response.ok) {
    const payload = await response.json();
    await handle(payload);
  } else {
    const {error} = await response.json();
    View.displayError(error);
  }
}

async function handleDrugsResponse(response) {
  await handleResponse(response, async function ({drugs, unnamed, clashes, ast}) {
    const labels = drugs.map(x => x.label);

    if (labels.length > 0) {
      try {
        await handleUrisResponse(await Request.uris(labels), ast);
      } catch (e) {
        View.displayNetworkError(e);
      }
    } else {
      View.displayNoDrugsError();
    }

    getFileContents(pml => {
      const pmlLines = pml.split('\n');

      if (unnamed.length > 0) {
        View.displayUnnamed(unnamed, pmlLines);
      }

      if (clashes.length > 0) {
        View.displayClashes(clashes, pmlLines);
      }
    });
  });
}

async function handleUrisResponse(response, ast) {
  await handleResponse(response, async function ({uris: {found, not_found: unidentifiedDrugs}}) {
    const labels = found.map(x => x.label);

    View.preparePMLDownloadButton(Request.generatePMLHref(ast));

    if (labels.length > 0) {
      View.displayDrugs(labels);
    }

    if (unidentifiedDrugs.length > 0) {
      View.displayUnidentifiedDrugs(unidentifiedDrugs);
    }

    if (found.length > 1) {
      try {
        await handleDdisResponse(await Request.ddis(found, ast));
      } catch (e) {
        View.displayNetworkError(e);
      }
    } else {
      View.displayDdis([], {});
    }
  });
}

async function handleDdisResponse(response) {
  await handleResponse(response, ({ddis}) => {
    View.displayDdis(ddis);
  });
}

const getFileContents = callback => {
  const file = View.fileInputElement.files[0];
  if (file) {
    const reader = new FileReader();
    reader.readAsText(file);
    reader.onload = e => {
      const contents = e.target.result;
      callback(contents);
    };
  } else {
    throw 'file could not be read';
  }
};
