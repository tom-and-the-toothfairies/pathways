defmodule Panacea.AsclepiusControllerTest do
  use Panacea.AuthorizedConnCase

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
        post conn, asclepius_path(conn, :ddis)
      end
    end

    test "returns an error when the drugs are invalid", %{conn: conn} do
      resp = post conn, asclepius_path(conn, :ddis), %{drugs: "foo"}

      assert resp.status == 422
    end

    test "returns an error when fewer than 2 drugs are provided", %{conn: conn} do
      drugs = ["http://purl.obolibrary.org/obo/CHEBI_27958"]
      resp = post conn, asclepius_path(conn, :ddis), %{drugs: drugs}

      assert resp.status == 422
    end

    test "returns the ddis for the given drugs", %{conn: conn} do
      drugs = [
        "http://purl.obolibrary.org/obo/DINTO_DB00214",
        "http://purl.obolibrary.org/obo/DINTO_DB00519",
      ]
      resp = post conn, asclepius_path(conn, :ddis), %{drugs: drugs}

      assert resp.status == 200
      assert response_body(resp) |> Map.get("ddis") ==
        [
          %{
            "drug_a" => "http://purl.obolibrary.org/obo/DINTO_DB00214",
            "drug_b" => "http://purl.obolibrary.org/obo/DINTO_DB00519",
            "label" => "torasemide/trandolapril DDI",
            "uri"   => "http://purl.obolibrary.org/obo/DINTO_11031"
          }
        ]
    end
  end
end
