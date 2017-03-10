defmodule Panacea.PmlController do
  use Panacea.Web, :controller

  def upload(conn, %{"upload" => %{"file" => %Plug.Upload{path: path}}}) do
    path
    |> File.read()
    |> validate()
    |> parse()
    |> to_result()
    |> Panacea.BaseController.respond(conn)
  end

  defp validate({:ok, str}) do
    if String.valid?(str) do
      {:ok, str}
    else
      {:error, {:encoding_error, "File is not UTF-8 encoded."}}
    end
  end

  defp parse({:ok, contents}),  do: Panacea.Pml.Parser.parse(contents)
  defp parse({:error, reason}), do: {:error, reason}

  defp to_result({:ok, drugs}),     do: {:ok, %{drugs: drugs}}
  defp to_result({:error, reason}), do: {:error, reason}
end
