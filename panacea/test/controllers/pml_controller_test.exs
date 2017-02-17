defmodule Panacea.PmlControllerTest do
  use Panacea.ConnCase

  describe "upload" do

    # TODO flash message on page (instead of error)
    test "without file", %{conn: conn} do
      assert_raise Phoenix.ActionClauseError, fn ->
        conn = post conn, "/api/pml"
      end
    end

    test "with file returns file contents", %{conn: conn} do
      filename = "example.pml"
      file_path = "test/fixtures/" <> filename
      { :ok, file_text } = File.read file_path
      upload = %Plug.Upload{ path: file_path, filename: filename }

      conn = post conn, "/api/pml", %{ :form_params => %{ :file => upload }}
      assert conn.resp_body == file_text
    end
  end

end
