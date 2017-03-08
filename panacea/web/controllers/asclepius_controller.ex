defmodule Panacea.AsclepiusController do
  use Panacea.Web, :controller
  alias Panacea.Asclepius

  def uris_for_labels(conn, %{"labels" => labels}) do
    labels
    |> Asclepius.uris_for_labels()
    |> respond(:uris, conn)
  end

  def ddis(conn, %{"drugs" => drugs}) do
    drugs
    |> Asclepius.ddis()
    |> respond(:ddis, conn)
  end

  defp respond({:ok, data}, tag, conn) do
    conn
    |> put_status(:ok)
    |> json(%{tag => data})
  end

  defp respond({:error, {:bad_data, message}}, _tag, conn) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{message: message})
  end

  defp respond({:error, reason}, _tag, conn) do
    conn
    |> put_status(:internal_server_error)
    |> json(%{message: inspect(reason)})
  end
end
