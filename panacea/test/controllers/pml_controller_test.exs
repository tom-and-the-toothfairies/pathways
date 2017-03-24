defmodule Panacea.PmlControllerTest do
  use Panacea.AuthorizedConnCase

  @fixtures_dir "test/fixtures/"

  defp post_to_upload(conn, filename) do
    file_path = Path.join(@fixtures_dir, filename)
    upload = %Plug.Upload{path: file_path, filename: filename}

    post conn, pml_path(conn, :upload), %{upload: %{file: upload}}
  end

  describe "PmlController.upload/2" do
    test "raises an error when no file is provided", %{conn: conn} do
      assert_raise Phoenix.ActionClauseError, fn ->
        post conn, pml_path(conn, :upload)
      end
    end

    test "raises an error when the file is invalid", %{conn: conn} do
      assert_raise Phoenix.ActionClauseError, fn ->
        post conn, pml_path(conn, :upload), %{upload: %{file: "nonsense"}}
      end
    end

    test "returns an error for malformed pml", %{conn: conn} do
      conn = post_to_upload(conn, "bad.pml")

      assert conn.status == 422

      error = response_body(conn) |> Map.get("error")
      assert error["title"] =~ "Syntax error"
    end

    test "returns an error for incorrect filetype", %{conn: conn} do
      conn = post_to_upload(conn, "example.png")

      assert conn.status == 422

      error = response_body(conn) |> Map.get("error")
      assert error["title"]=~ "Encoding error"
    end

    test "identifies the drugs in correct pml", %{conn: conn} do
      conn = post_to_upload(conn, "no_ddis.pml")

      assert conn.status == 200
      assert response_body(conn) |> Map.get("drugs") == [
        %{"label" => "cocaine", "line" => 17},
        %{"label" => "paracetamol", "line" => 8}
      ]
    end

    test "identifies unnamed constructs in correct pml", %{conn: conn} do
      conn = post_to_upload(conn, "analysis/unnamed.pml")

      assert conn.status == 200
      assert response_body(conn) |> Map.get("unnamed") == [
        %{"type" => "task", "line" => 2}
      ]
    end

    test "identifies name clashes between constructs in correct pml", %{conn: conn} do
      conn = post_to_upload(conn, "analysis/clashes.pml")

      assert conn.status == 200
      assert response_body(conn) |> Map.get("clashes") == [
        %{
          "name" => 'baz',
          "conflicts" => [
            %{"line" => 9, "type" => "action"},
            %{"line" => 3, "type" => "action"}
          ]
        },
        %{
          "name" => 'baz2',
          "conflicts" => [
            %{"line" => 7, "type" => "action"},
            %{"line" => 5, "type" => "action"}
          ]
        }
      ]
    end

    test "returns the AST representation of the pml", %{conn: conn} do
      filename = "no_ddis.pml"
      file_path = Path.join(@fixtures_dir, filename)

      conn = post_to_upload(conn, filename)

      assert conn.status == 200

      {:ok, ast} =
        file_path
        |> File.read!()
        |> Panacea.Pml.Parser.parse()

      received_ast =
        conn
        |> response_body()
        |> Map.get("ast")
        |> Base.decode64!()
        |> :erlang.binary_to_term()

      assert received_ast == ast
    end
  end
end
