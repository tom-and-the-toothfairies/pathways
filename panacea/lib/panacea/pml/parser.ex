defmodule Panacea.Pml.Parser do
  alias Panacea.Pml.Parser.{Logger, Error}

  @type drug :: String.t

  @spec parse(String.t) :: {:ok, [drug]} | {:error, String.t}
  def parse(str) do
    str
    |> to_charlist()
    |> tokens()
    |> generate_ast()
    |> log_result()
  end

  defp tokens(str) do
    :pml_lexer.string(str)
  end

  defp generate_ast({:ok, tokens, _}) do
    :pml_parser.parse(tokens)
  end
  defp generate_ast({:error, reason, _}) do
    {:error, reason}
  end

  defp log_result({:error, reason}) do
    formatted = Error.format(reason)
    Logger.error("PML Parsing error: #{formatted}")

    {:error, {:syntax_error, formatted}}
  end
  defp log_result({:ok, ast}) do
    Logger.info("PML Analysis success")
    {:ok, ast}
  end
end
