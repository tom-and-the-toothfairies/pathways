defmodule Panacea.PmlControllerTest do
  use Panacea.ConnCase

  @fixtures_dir "test/fixtures/"

  describe "PmlController.upload/2" do
    test "raises an error when no file is provided", %{conn: conn} do
      assert_raise Phoenix.ActionClauseError, fn ->
        post conn, "/api/pml"
      end
    end

    test "raises an error when the file is invalid", %{conn: conn} do
      assert_raise Phoenix.ActionClauseError, fn ->
        post conn, "/api/pml", %{ file: "nonsense" }
      end
    end

    test "returns an error for malformed pml", %{conn: conn} do
      filename = "bad.pml"
      file_path = Path.join(@fixtures_dir, filename)
      upload = %Plug.Upload{path: file_path, filename: filename}

      conn = post conn, "/api/pml", %{ file: upload }

      assert response(conn, 200) =~ ~s("status":"error")
    end

    test "identifies the drugs in correct pml", %{conn: conn} do
      filename = "drugs.pml"
      file_path = Path.join(@fixtures_dir, filename)
      upload = %Plug.Upload{path: file_path, filename: filename}

      conn = post conn, "/api/pml", %{ file: upload }

      assert response(conn, 200) =~ ~s("drugs":["chebi:1234","dinto:1234"])
    end
  end
end
