defmodule Panacea.Pml.AnalysisTest do
  use ExUnit.Case

  @fixtures_dir "test/fixtures"

  defp analyse_test_file do
    {:ok, pml} = Path.join(@fixtures_dir, "analysis_test.pml") |> File.read()

    {:ok, ast} = Panacea.Pml.Parser.parse(pml)
    {:ok, analysis} = Panacea.Pml.Analysis.run(ast)
    analysis
  end

  describe "run/1" do
    test "it identifies drugs in the AST" do
      assert analyse_test_file().drugs ==
        [
          %{label: "cocaine", line: 17},
          %{label: "paracetamol", line: 8}
        ]
    end

    test "it identifies unnamed constructs in the AST" do
      assert analyse_test_file().unnamed == [%{type: :task, line: 2}]
    end
  end
end
