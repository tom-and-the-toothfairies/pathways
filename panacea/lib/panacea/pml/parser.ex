defmodule Panacea.Pml.Parser do
  def parse(str) do
    str
    |> to_charlist()
    |> tokens()
    |> do_parse()
  end

  def tokens(str) do
    :pml_lexer.string(str)
  end

  defp do_parse({:ok, tokens, _}) do
    :pml_parser.parse(tokens)
  end
  defp do_parse(error_reason) do
    {:error, error_reason}
  end
end
