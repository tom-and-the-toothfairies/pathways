defmodule Panacea.AstControllerTest do
  use Panacea.AuthorizedConnCase

  describe "AstController.to_pml/2" do
    test "raises an error when no ast is provided", %{conn: conn} do
      assert_raise Phoenix.ActionClauseError, fn ->
        post conn, ast_path(conn, :to_pml)
      end
    end

    test "returns an error for non base64 encoded asts", %{conn: conn} do
      conn = post conn, ast_path(conn, :to_pml), %{ast: "foo"}

      assert conn.status == 422

      error = response_body(conn) |> Map.get("error")
      assert error["title"]=~ "Encoding error"
    end

    test "turns the provided ast into pml", %{conn: conn} do
      pml = """
      process foo {
        task bar {
          action baz {
            tool { "pills" }
            script { "eat the pills" }
            agent { "patient" }
            requires { drug { "torasemide" } }
            provides { "a cured patient" }
          }
          action baz2 {
            tool { "pills" }
            script { "eat the pills" }
            agent { (intangible) (inscrutable) pml.wtf && ("foo" || 1 != 2) }
            requires { drug { "trandolapril" } }
            provides { "a cured patient" }
          }
        }
      }
      """
      |> String.replace_trailing("\n", "")

      {:ok, ast} = Panacea.Pml.Parser.parse(pml)

      encoded_ast =
        ast
        |> :erlang.term_to_binary()
        |> Base.encode64()

      conn = post conn, ast_path(conn, :to_pml), %{ast: encoded_ast}

      assert conn.status == 200
      assert conn.resp_body == pml
    end
  end
end
