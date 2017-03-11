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
    const drugsResponse = await Request.drugs(this);
    handleDrugsResponse(drugsResponse);

    this.reset();
  } catch (err) {
  }
  View.restoreFileForm();
}

async function handleResponse(response, handle) {
  if (response.ok) {
    const payload = await response.json();
    handle(payload);
  } else {
    const {error} = await response.json();
    View.displayError(error);
  }
}

const handleDrugsResponse = drugsResponse => {
  handleResponse(drugsResponse, async function ({drugs}) {
    const labels = drugs.map(x => x.label);

    if (labels.length > 0) {
      View.displayDrugs(labels);
      const urisResponse = await Request.uris(labels);
      handleUrisResponse(urisResponse);
    } else {
     View.displayError({title: "Pathway error", detail: "No drugs found"});
    }
  });
};

const handleUrisResponse = urisResponse => {
  handleResponse(urisResponse, async function ({uris: {found, not_found: unidentifiedDrugs}}) {
    const uris = found.map(x => x.uri);

    if (unidentifiedDrugs.length > 0) {
      View.displayUnidentifiedDrugs(unidentifiedDrugs);
    }

    if (uris.length >= 2) {
      const ddisResponse = await Request.ddis(uris);
      handleDdisResponse(ddisResponse);

    } else {
      console.log("by definition ddis require more than one drug");
    }
  });
};

const handleDdisResponse = ddisResponse => {
  handleResponse(ddisResponse, ({ddis}) => {
    View.displayDdis(ddis);
  });
};
