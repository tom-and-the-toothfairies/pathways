defmodule Panacea.Pml.Parser do
  alias Panacea.Pml.Parser.Error

  @type drug :: String.t

  @spec parse(String.t) :: {:ok, [drug]} | {:error, String.t}
  def parse(str) do
    str
    |> to_charlist()
    |> tokens()
    |> do_parse()
    |> to_result()
  end

  defp tokens(str) do
    :pml_lexer.string(str)
  end

  defp do_parse({:ok, tokens, _}) do
    :pml_parser.parse(tokens)
  end
  defp do_parse({:error, reason, _}) do
    {:error, reason}
  end

  defp to_result({:error, reason}) do
    {:error, Error.format(reason)}
  end
  defp to_result({:ok, drugs}) do
    {:ok, drugs}
  end
end
