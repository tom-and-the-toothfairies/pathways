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
      this.reset();
    } else {
      // TODO: When API stops sending 200s change this to do the 'error' bit below
      console.log('Request failed');
    }
  } catch (err) {
    console.log(err);
  }
}

const renderFileResponse = data => {
  const successResultMessage = document.getElementById('success-result-message');
  const errorResultMessage = document.getElementById('error-result-message');
  const successPanel = document.getElementById('success-panel');
  const errorPanel = document.getElementById('error-panel');

  if (data.status === 'error') {
      // TODO: When API stops sending 200s change this
    errorResultMessage.innerHTML = data.message
    errorPanel.style.display = 'block';
    successPanel.style.display = 'none';
  } else {
    successResultMessage.innerHTML = JSON.stringify(data.drugs)
    errorPanel.style.display = 'none';
    successPanel.style.display = 'block';
  }
}
