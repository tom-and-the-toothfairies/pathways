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
    headers: headers
  });
}

export const drugs = formData => {
  return post('/api/pml', formData, formHeaders);
};

export const uris = labels => {
  return post('/api/uris', JSON.stringify({labels}), defaultHeaders);
};

export const ddis = drugs => {
  return post('/api/ddis', JSON.stringify({drugs}), defaultHeaders);
};
