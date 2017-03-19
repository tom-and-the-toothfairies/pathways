defmodule Panacea.PmlController do
  use Panacea.Web, :controller

  def upload(conn, %{"upload" => %{"file" => %Plug.Upload{path: path}}}) do
    path
    |> File.read()
    |> validate()
    |> parse()
    |> analyse()
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

  defp analyse({:ok, ast}), do: Panacea.Pml.Analysis.run(ast)
  defp analyse({:error, reason}), do: {:error, reason}

  defp to_result({:ok, analysis}), do: {:ok, analysis}
  defp to_result({:error, reason}), do: {:error, reason}
end
