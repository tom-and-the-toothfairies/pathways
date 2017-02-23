defmodule Panacea.PmlController do
  use Panacea.Web, :controller

  def upload(conn, %{"file" => %Plug.Upload{path: path}}) do
    path
    |> File.read
    |> validate
    |> parse
    |> respond(conn)
  end

  defp validate({:ok, str}) do
    if String.valid?(str) do
      {:ok, str}
    else
      {:error, "invalid filetype"}
    end
  end

  defp parse({:ok, contents}) do
    Panacea.Pml.Parser.parse(contents)
  end
  defp parse({:error, message}) do
    {:error, message}
  end

  defp respond({:ok, drugs}, conn) do
    json conn, %{status: :ok, drugs: drugs}
  end
  defp respond({:error, message}, conn) do
    json conn, %{status: :error, message: message}
  end
end
