const apiAccessToken = document.getElementById('api-access-token').content;
const formHeaders = new Headers({authorization: apiAccessToken});
const defaultHeaders = new Headers({
  "Authorization": apiAccessToken,
  "Content-Type": "application/json",
  "Accept": "application/json, text/plain, */*"
});

async function post(endpoint, body, headers) {
  return fetch(endpoint, {
    method: 'POST',
    body: body,
    credentials: 'same-origin',
    headers: headers
  });
}

export const drugs = formContents => {
  return post('/api/pml', new FormData(formContents), formHeaders);
};

export const uris = labels => {
  return post('/api/uris', JSON.stringify({labels: labels}), defaultHeaders);
};

export const ddis = uris => {
  return post('/api/ddis', JSON.stringify({drugs: uris}), defaultHeaders);
};
