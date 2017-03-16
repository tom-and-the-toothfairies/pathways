defmodule Panacea.Pml.Parser do
  alias Panacea.Pml.Parser.{Logger, Error}

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
    formatted = Error.format(reason)
    Logger.error("PML Parsing error: #{formatted}")

    {:error, {:syntax_error, formatted}}
  end
  defp to_result({:ok, drugs}) do
    result = for {label, line} <- drugs, do: %{label: label, line: line}

    Logger.info(["PML Parsing success: ", inspect(result)])

    {:ok, result}
  end

  def test do
    {:ok, f} = File.read("test/fixtures/ddis.pml")
    f
    |> to_charlist()
    |> :pml_lexer.string()
    |> elem(1)
    |> :pml_parser.parse()
  end
end
