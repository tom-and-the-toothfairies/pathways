import * as View from './view';
import * as Request from './request';

export default class RequestChain {
  constructor(pml) {
    this.lines = pml.split('\n');
  }

  async start(formData) {
    await this.handleDrugsResponse(await Request.drugs(formData));
  }

  async handleResponse(response, handle) {
    if (response.ok) {
      const payload = await response.json();
      await handle(payload);
    } else {
      const {error} = await response.json();
      error.detail = `<strong>${error.detail}</strong>`;
      View.displayError(error, this.lines);
    }
  }

  async handleDrugsResponse(response) {
    await this.handleResponse(response, async ({drugs, unnamed, clashes, ast}) => {
      // we have unused line information in the drugs object here
      View.preparePMLDownloadButton(Request.generatePMLHref(ast));
      const labels = drugs.map(x => x.label);

      if (labels.length > 0) {
        try {
          await this.handleUrisResponse(await Request.uris(labels), ast);
        } catch (e) {
          View.displayNetworkError(e);
        }
      } else {
        View.displayNoDrugsError();
      }

      View.displayUnnamed(unnamed, this.lines);
      View.displayClashes(clashes, this.lines);
    });
  }

  async handleUrisResponse(response, ast) {
    await this.handleResponse(response, async ({uris: {found, not_found: unidentifiedDrugs}}) => {
      View.displayDrugs(found);
      View.displayUnidentifiedDrugs(unidentifiedDrugs);

      if (found.length > 1) { // ddis require at least 2 drugs
        try {
          await this.handleDdisResponse(await Request.ddis(found, ast));
        } catch (e) {
          View.displayNetworkError(e);
        }
      } else {
        View.displayNoDdis();
      }
    });
  }

  async handleDdisResponse(response) {
    await this.handleResponse(response, ({ddis}) => {
      View.displayDdis(ddis);
    });
  }
}
