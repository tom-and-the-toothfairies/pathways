import "phoenix_html"

const file_form = document.getElementById('file-form')
const file_input = document.getElementById('file-input')
const submit_button = document.getElementById('file-submit')
const parse_result_div = document.getElementById('parse-result')

submit_button.addEventListener('click', (e) => {
  e.preventDefault()
  submit_file()
})

const submit_file = () => {
  let file = file_input.files[0]

  var formData = new FormData(file_form)

  formData.append("file", file)

  var request = new XMLHttpRequest()
  request.open("POST", `/api/pml`, true)
  request.onreadystatechange = () => {
    if (request.readyState == 4 && request.status == 200) {
      var decoded_response = JSON.parse(request.response)
      render_file_response(decoded_response)
    }
  }
  request.send(formData)
  file_form.reset()
}

const render_file_response = (data) => {
  if (data.status == "error"){
    parse_result_div.innerHTML = `Error parsing pml: ${data.message}`
  } else {
    parse_result_div.innerHTML = `We have found the following drugs: ${JSON.stringify(data.drugs)}`
  }
}
