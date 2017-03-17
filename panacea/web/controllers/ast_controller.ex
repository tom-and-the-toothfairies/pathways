defmodule Panacea.AstController do
  use Panacea.Web, :controller

  def to_pml(conn, %{"ast" => encoded_ast}) do encoded_ast
    |> decode()
    |> to_erlang_term()
    |> to_pml()
    |> respond(conn)
  end

  defp decode(encoded_ast) do
    case Base.decode64(encoded_ast) do
      {:ok, binary} ->
        {:ok, binary}
      :error ->
        {:error, {:encoding_error, "AST is not base64 encoded."}}
    end
  end

  defp to_erlang_term({:ok, binary}) do
    {:ok, :erlang.binary_to_term(binary)}
  end
  defp to_erlang_term({:error, reason}) do
    {:error, reason}
  end

  defp to_pml({:ok, ast}) do
    {:ok, Panacea.Pml.Ast.to_pml(ast)}
  end
  defp to_pml({:error, reason}) do
    {:error, reason}
  end

  defp respond({:ok, pml}, conn) do
    conn
    |> put_resp_header("content-disposition", ~s(attachment; filename="pml-tx.pml"))
    |> send_resp(200, pml)
  end
  defp respond({:error, reason}, conn) do
    Panacea.BaseController.respond({:error, reason}, conn)
  end
end
