defmodule Panacea.PmlController do
  use Panacea.Web, :controller

  def upload(conn, %{"form_params" => form_params}) do
    %{"file" => file} = form_params
    # do magic with the file here...
    # IO.inspect file
    conn
    |> put_resp_content_type("application/octet-stream", nil)
    |> put_resp_header("content-disposition", ~s[attachment; filename="#{file.filename}"])
    |> send_file(200, file.path)
  end
end
