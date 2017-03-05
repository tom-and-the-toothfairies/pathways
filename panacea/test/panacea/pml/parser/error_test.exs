defmodule Panacea.Pml.Parser.ErrorTest do
  use ExUnit.Case, async: true
  alias Panacea.Pml.Parser.Error

  describe "format" do
    @tag :err_highlights
    test "it turns a lexer error tuple into a nice string" do
      {:error, error, _} = "process ," |> to_charlist |> :pml_lexer.string


      assert error |> Error.format == "line 1 -- unrecognized token ','"
    end

    @tag :err_highlights
    test "it turns a parser error tuple into a nice string" do
      {:ok, tokens, _} = "process { foo }" |> to_charlist |> :pml_lexer.string
      {:error, error} = tokens |> :pml_parser.parse

      assert error |> Error.format == "line 1 -- syntax error before: '{'"
    end
  end
end
