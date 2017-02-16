defmodule Panacea.Pml.ParserTest do
  use ExUnit.Case, async: true
  alias Panacea.Pml.Parser

  describe "parse/1" do
    test "it parses correct pml" do
      pml = """
      process foo {
        task bar {
          action baz {}
        }
      }
      """

      assert Parser.parse(pml) ==
        {:ok, {:process, [{:task, [:action]}]}}
    end

    test "it rejects incorrect pml" do
      pml = """
      process foo {
      """

      assert {:error, {1, :pml_parser, _}} = Parser.parse(pml)
    end
  end
end
