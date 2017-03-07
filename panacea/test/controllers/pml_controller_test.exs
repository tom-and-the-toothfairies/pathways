defmodule Panacea.PmlControllerTest do
  use Panacea.AuthorizedConnCase

  @fixtures_dir "test/fixtures/"

  defp response_body(conn) do
    Poison.decode!(conn.resp_body)
  end

  describe "PmlController.upload/2" do
    @tag :err_highlights
    @tag :pml_loading
    test "raises an error when no file is provided", %{conn: conn} do
      assert_raise Phoenix.ActionClauseError, fn ->
        post conn, pml_path(conn, :upload)
      end
    end

    @tag :err_highlights
    @tag :pml_loading
    test "raises an error when the file is invalid", %{conn: conn} do
      assert_raise Phoenix.ActionClauseError, fn ->
        post conn, pml_path(conn, :upload), %{upload: %{file: "nonsense"}}
      end
    end

    @tag :err_highlights
    @tag :pml_analysis
    @tag :pml_loading
    test "returns an error for malformed pml", %{conn: conn} do
      filename = "bad.pml"
      file_path = Path.join(@fixtures_dir, filename)
      upload = %Plug.Upload{path: file_path, filename: filename}

      conn = post conn, pml_path(conn, :upload), %{upload: %{file: upload}}

      assert conn.status == 422
      assert response_body(conn) |> Map.get("message") =~ "syntax error"
    end

    @tag :err_highlights
    @tag :pml_loading
    test "returns an error for incorrect filetype", %{conn: conn} do
      filename = "example.png"
      file_path = Path.join(@fixtures_dir, filename)
      upload = %Plug.Upload{path: file_path, filename: filename}

      conn = post conn, pml_path(conn, :upload), %{upload: %{file: upload}}

      assert conn.status == 422
      assert response_body(conn) |> Map.get("message") =~ "Invalid filetype"
    end

    @tag :identify_drugs
    @tag :pml_analysis
    @tag :pml_loading
    test "identifies the drugs in correct pml", %{conn: conn} do
      filename = "no_ddis.pml"
      file_path = Path.join(@fixtures_dir, filename)
      upload = %Plug.Upload{path: file_path, filename: filename}

      conn = post conn, pml_path(conn, :upload), %{upload: %{file: upload}}

      assert conn.status == 200
      assert response_body(conn) |> Map.get("drugs") == ["chebi:1234", "dinto:DB1234"]
    end

    @tag :identify_ddis
    @tag :pml_loading
    test "identifies DDIs with the drugs from the pml", %{conn: conn} do
      filename = "ddis.pml"
      file_path = Path.join(@fixtures_dir, filename)
      upload = %Plug.Upload{path: file_path, filename: filename}

      conn = post conn, pml_path(conn, :upload), %{upload: %{file: upload}}

      assert conn.status == 200
      assert response_body(conn) |> Map.get("ddis") == [
          %{
            "drug_a" => "chebi:421707",
            "drug_b" => "chebi:465284",
            "label" => "abacavir/ganciclovir DDI",
            "uri" => "http://purl.obolibrary.org/obo/DINTO_05759"
          },
          %{
            "drug_a" => "chebi:421707",
            "drug_b" => "dinto:DB00503",
            "label" => "abacavir/ritonavir DDI",
            "uri" => "http://purl.obolibrary.org/obo/DINTO_11043"
          }
        ]
    end
  end
end
