import "babel-polyfill";
import "phoenix_html";

document.getElementById('file-form').addEventListener('submit', e => {
  e.preventDefault();
  submitFile.bind(e.target)();
});

async function submitFile() {
  try {
    const response = await fetch(this.action, {
      method: 'POST',
      body: new FormData(this),
      credentials: 'same-origin'
    });

    if (response.ok) {
      renderFileResponse(await response.json());
    } else {
      renderFileError(await response.json());
    }
    this.reset();
  } catch (err) {
    console.log(err);
  }
}

const successPanel = document.getElementById('success-panel');
const errorPanel = document.getElementById('error-panel');

const renderFileResponse = data => {
  const successResultMessage = document.getElementById('success-result-message');
  successResultMessage.innerHTML = JSON.stringify(data.drugs);
  errorPanel.style.display = 'none';
  successPanel.style.display = 'block';
};

const renderFileError = data => {
  const errorResultMessage = document.getElementById('error-result-message');
  errorResultMessage.innerHTML = data.message;
  errorPanel.style.display = 'block';
  successPanel.style.display = 'none';
};
