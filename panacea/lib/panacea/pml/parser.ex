defmodule Panacea.Pml.Parser do
  def parse(str) do
    str
    |> to_charlist()
    |> tokens()
    |> do_parse()
  end

  defp tokens(str) do
    :pml_lexer.string(str)
  end

  defp do_parse({:ok, tokens, _}) do
    case :pml_parser.parse(tokens) do
      {:ok, result} ->
        {:ok, result}
      {:error, reason} ->
        {:error, reason}
    end
  end
  defp do_parse(error_reason) do
    {:error, error_reason}
  end
end
