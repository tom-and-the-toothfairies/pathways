defmodule Panacea.Pml.Analysis.DrugsTest do
  use ExUnit.Case

  @fixtures_dir "test/fixtures/analysis"

  describe "run/1" do
    test "it identifies drugs in the AST" do
      {:ok, pml} = Path.join(@fixtures_dir, "drugs.pml") |> File.read()

      {:ok, ast} = Panacea.Pml.Parser.parse(pml)
      drugs = Panacea.Pml.Analysis.Drugs.run(ast)

      assert drugs ==
        [
          %{label: "cocaine", line: 17},
          %{label: "paracetamol", line: 8}
        ]
    end
  end
end
