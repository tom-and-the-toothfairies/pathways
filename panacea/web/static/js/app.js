import "phoenix_html"

const file_form = document.getElementById('file-form')
const file_input = document.getElementById('file-input')
const submit_button = document.getElementById('file-submit')

const success_result_message = document.getElementById('success-result-message')
const error_result_message = document.getElementById('error-result-message')
const success_panel = document.getElementById('success-panel')
const error_panel = document.getElementById('error-panel')

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
    error_result_message.innerHTML = data.message
    error_panel.style.display = "block";
    success_panel.style.display = "none";
  } else {
    success_result_message.innerHTML = JSON.stringify(data.drugs)
    error_panel.style.display = "none";
    success_panel.style.display = "block";
  }
}
