import "babel-polyfill";
import "phoenix_html";
import "whatwg-fetch";
import * as Request from "./request";
import * as View from "./view";


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
  await handleResponse(response, async function ({drugs}) {
    const labels = drugs.map(x => x.label);

    if (labels.length > 0) {
      try {
        await handleUrisResponse(await Request.uris(labels));
      } catch (e) {
        View.displayNetworkError(e);
      }
    } else {
      View.displayNoDrugsError();
    }
  });
}

async function handleUrisResponse(response) {
  await handleResponse(response, async function ({uris: {found, not_found: unidentifiedDrugs}}) {
    const uris = found.map(x => x.uri);
    const labels = found.map(x => x.label);

    View.displayDrugs(labels);

    if (unidentifiedDrugs.length > 0) {
      View.displayUnidentifiedDrugs(unidentifiedDrugs);
    }

    if (uris.length > 1) {
      try {
        await handleDdisResponse(await Request.ddis(uris));
      } catch (e) {
        View.displayNetworkError(e);
      }
    } else {
      View.displayDdis([]);
    }
  });
}

async function handleDdisResponse(response) {
  await handleResponse(response, ({ddis}) => {
    View.displayDdis(ddis);
  });
}
