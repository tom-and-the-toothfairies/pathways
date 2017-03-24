defmodule Panacea.Pml.Analysis.UnnamedTest do
  use ExUnit.Case

  @fixtures_dir "test/fixtures/analysis"

  describe "run/1" do
    test "it identifies unnamed constructs in the AST" do
      {:ok, pml} = Path.join(@fixtures_dir, "unnamed.pml") |> File.read()

      {:ok, ast} = Panacea.Pml.Parser.parse(pml)
      unnamed = Panacea.Pml.Analysis.Unnamed.run(ast)

      assert unnamed == [%{type: :task, line: 2}]
    end
  end
end
