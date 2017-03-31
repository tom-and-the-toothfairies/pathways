import 'bootstrap.native';
import 'whatwg-fetch';
import { RequestChain } from './request-chain';
import * as View from './view';

View.fileForm.addEventListener('submit', e => {
  e.preventDefault();
  const formData = new FormData(e.target);
  submitFile(formData);
  e.target.reset();
});

const submitFile = formData => {
  View.hideFileForm();
  View.hideResults();
  try {
    retrievePML(pml => {
      const requestChain = new RequestChain(pml);
      requestChain.start(formData);
    });
  } catch (e) {
    View.displayNetworkError(e);
  }
  View.restoreFileForm();
};

const retrievePML = callback => {
  const file = View.fileInput.files[0];
  if (file) {
    const reader = new FileReader();
    reader.readAsText(file);
    reader.onload = e => {
      const rawPML = e.target.result;
      callback(rawPML);
    };
  } else {
    throw 'file could not be read';
  }
};
