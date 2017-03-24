defmodule Panacea.AsclepiusController do
  use Panacea.Web, :controller
  alias Panacea.Asclepius

  def uris_for_labels(conn, %{"labels" => labels}) do
    labels
    |> Asclepius.uris_for_labels()
    |> to_result(:uris)
    |> Panacea.BaseController.respond(conn)
  end

  def ddis(conn, %{"ast" => ast, "drugs" => drugs}) when is_list(drugs) do
    drugs
    |> Enum.map(fn %{"uri" => uri} -> uri end)
    |> Asclepius.ddis()
    |> decode_ast(ast)
    |> categorize_ddis(drugs)
    |> to_result(:ddis)
    |> Panacea.BaseController.respond(conn)
  end

  defp decode_ast({:ok, ddis}, encoded_ast) do
    case Panacea.Pml.Ast.decode(encoded_ast) do
      {:ok, ast} ->
        {:ok, ddis, ast}
      {:error, reason} ->
        {:error, reason}
    end
  end
  defp decode_ast({:error, reason}, _), do: {:error, reason}

  defp categorize_ddis({:ok, ddis, ast}, drugs) do
    {:ok, Panacea.Pml.Analysis.Ddis.run(ast, ddis, drugs)}
  end
  defp categorize_ddis({:error, reason}, _), do: {:error, reason}

  defp to_result({:ok, value}, key), do: {:ok, %{key => value}}
  defp to_result({:error, reason}, _),  do: {:error, reason}
end
