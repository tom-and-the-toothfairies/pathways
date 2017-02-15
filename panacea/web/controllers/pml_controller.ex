defmodule Panacea.PmlController do
  use Panacea.Web, :controller

  def upload(conn, %{"pml" => pml}) do
    File.open!(pml.path, [:read], fn(file) ->
      raw_file = IO.binread(file, :all)
      conn
      |> put_resp_content_type("application/octet-stream", nil)
      |> put_resp_header("content-disposition", ~s[attachment; filename="#{pml.filename}"])
      |> send_resp(200, raw_file)
    end)
  end
end
