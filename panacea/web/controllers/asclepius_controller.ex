defmodule Panacea.AsclepiusController do
  use Panacea.Web, :controller
  alias Panacea.Asclepius

  def uris_for_labels(conn, %{"labels" => labels}) do
    labels
    |> Asclepius.uris_for_labels()
    |> to_result(:uris)
    |> Panacea.BaseController.respond(conn)
  end

  def ddis(conn, %{"drugs" => drugs}) do
    drugs
    |> Asclepius.ddis()
    |> to_result(:ddis)
    |> Panacea.BaseController.respond(conn)
  end

  defp to_result({:ok, value}, key), do: {:ok, %{key => value}}
  defp to_result({:error, reason}, _),  do: {:error, reason}
end
