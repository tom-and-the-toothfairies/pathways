const apiAccessToken = document.getElementById('api-access-token').content;
const formHeaders = new Headers({authorization: apiAccessToken});
const defaultHeaders = new Headers({
  'Authorization': apiAccessToken,
  'Content-Type': 'application/json',
  'Accept': 'application/json, text/plain, */*'
});

const post = (endpoint, body, headers) => {
  return fetch(endpoint, {
    method: 'POST',
    body,
    headers
  });
};

export const drugs = formData => {
  return post('/api/pml', formData, formHeaders);
};

export const uris = labels => {
  return post('/api/uris', JSON.stringify({labels}), defaultHeaders);
};

export const ddis = (drugs, ast) => {
  return post('/api/ddis', JSON.stringify({drugs, ast}), defaultHeaders);
};

export const generatePMLHref = ast => {
  const endpoint = '/api/ast';
  const astParam = `ast=${encodeURIComponent(ast)}`;
  const tokenParam = `authorization_token=${encodeURIComponent(apiAccessToken)}`;
  return `${endpoint}?${astParam}&${tokenParam}`;
};
