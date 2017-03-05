defmodule Panacea.PmlController do
  use Panacea.Web, :controller

  def upload(conn, %{"upload" => %{"file" => %Plug.Upload{path: path}}}) do
    path
    |> File.read
    |> validate
    |> parse
    |> get_ddis
    |> respond(conn)
  end

  defp validate({:ok, str}) do
    if String.valid?(str) do
      {:ok, str}
    else
      {:error, "Invalid filetype"}
    end
  end

  defp parse({:ok, contents}) do
    Panacea.Pml.Parser.parse(contents)
  end
  defp parse({:error, message}) do
    {:error, message}
  end

  defp get_ddis({:ok, drugs}) do
    {:ok, ddis} = Panacea.Asclepius.ddis(drugs)
    {:ok, %{drugs: drugs, ddis: ddis}}
  end
  defp get_ddis({:error, message}) do
    {:error, message}
  end

  defp respond({:ok, response}, conn) do
    conn
    |> put_status(:ok)
    |> json(response)
  end
  defp respond({:error, message}, conn) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{message: message})
  end
end
