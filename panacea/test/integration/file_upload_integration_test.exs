defmodule Panacea.FileUploadIntegrationTest do
  use Panacea.IntegrationCase, async: true

  # TODO write how to test feature in readme (once docker set up nicely)
  test "Basic file upload", %{conn: conn} do
    filename = "example.pml"
    file_path = "test/fixtures/" <> filename
    { :ok, file_text } = File.read file_path
    upload = %Plug.Upload{ path: file_path, filename: filename }

    get(conn, page_path(conn, :index))
    |> follow_form(%{ :form_params => %{ :file => upload }})
    |> assert_response(status: 200, body: file_text)
  end

end
