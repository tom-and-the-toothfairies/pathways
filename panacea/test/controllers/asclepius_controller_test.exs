defmodule Panacea.AsclepiusControllerTest do
  use Panacea.AuthorizedConnCase

  defp encoded_ast() do
    pml = """
    process death {
      action foo {
        requires { drug { "torasemide" } }
      }
      action bar {
        requires { drug { "trandolapril" } }
      }
    }
    """
    {:ok, ast} = Panacea.Pml.Parser.parse(pml)
    ast
    |> :erlang.term_to_binary()
    |> Base.encode64()
  end

  describe "AsclepiusController.uris_for_labels/2" do
    test "raises an error when no labels are provided", %{conn: conn} do
      assert_raise Phoenix.ActionClauseError, fn ->
        post conn, asclepius_path(conn, :uris_for_labels)
      end
    end

    test "returns an error when the labels are invalid", %{conn: conn} do
      resp = post conn, asclepius_path(conn, :uris_for_labels), %{labels: "foo"}

      assert resp.status == 422
    end

    test "returns the uris for the given labels", %{conn: conn} do
      labels = ["cocaine", "paracetamol", "flat seven up"]
      resp = post conn, asclepius_path(conn, :uris_for_labels), %{labels: labels}

      assert resp.status == 200
      assert response_body(resp) |> Map.get("uris") ==
        %{
          "found" => [
            %{
              "label" => "cocaine",
              "uri" => "http://purl.obolibrary.org/obo/CHEBI_27958"
            },
            %{
              "label" => "paracetamol",
              "uri" => "http://purl.obolibrary.org/obo/CHEBI_46195"
            }
          ],
          "not_found" => [
            "flat seven up"
          ]
        }
    end
  end

  describe "AsclepiusController.ddis/2" do
    test "raises an error when no drugs are provided", %{conn: conn} do
      assert_raise Phoenix.ActionClauseError, fn ->
        post conn, asclepius_path(conn, :ddis, %{ast: "foo"})
      end
    end

    test "raises an error when no ast is provided", %{conn: conn} do
      assert_raise Phoenix.ActionClauseError, fn ->
        post conn, asclepius_path(conn, :ddis, %{drugs: []})
      end
    end

    test "raises an error when the drugs are invalid", %{conn: conn} do
      ast = encoded_ast()
      assert_raise Phoenix.ActionClauseError, fn ->
        post conn, asclepius_path(conn, :ddis), %{drugs: "foo", ast: ast}
      end
    end

    test "returns an error when fewer than 2 drugs are provided", %{conn: conn} do
      drugs = [
        %{"uri" => "http://purl.obolibrary.org/obo/CHEBI_27958", "label" => "cocaine"}
      ]
      ast = encoded_ast()
      resp = post conn, asclepius_path(conn, :ddis), %{drugs: drugs, ast: ast}

      assert resp.status == 422
    end

    test "returns the ddis for the given drugs", %{conn: conn} do
      drugs = [
        %{
          "uri" => "http://purl.obolibrary.org/obo/DINTO_DB00214",
          "label" => "torasemide"
        },
        %{
          "uri" => "http://purl.obolibrary.org/obo/DINTO_DB00519",
          "label" => "trandolapril"
        }
      ]
      ast = encoded_ast()
      resp = post conn, asclepius_path(conn, :ddis), %{drugs: drugs, ast: ast}

      assert resp.status == 200
      assert response_body(resp) |> Map.get("ddis") ==
        [
          %{
            "category" => "sequential",
            "drug_a" => "http://purl.obolibrary.org/obo/DINTO_DB00214",
            "drug_b" => "http://purl.obolibrary.org/obo/DINTO_DB00519",
            "label" => "torasemide/trandolapril DDI",
            "uri"   => "http://purl.obolibrary.org/obo/DINTO_11031",
            "enclosing_constructs" => [
              %{
                "type" => "process",
                "line" => 1
              }
            ]
          }
        ]
    end
  end
end
