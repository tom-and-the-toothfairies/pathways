defmodule Panacea.Pml.AnalysisTest do
  use ExUnit.Case

  @fixtures_dir "test/fixtures/analysis/"

  defp analyse_test_file(name) do
    {:ok, pml} = Path.join(@fixtures_dir, name) |> File.read()

    {:ok, ast} = Panacea.Pml.Parser.parse(pml)
    {:ok, analysis} = Panacea.Pml.Analysis.run(ast)
    analysis
  end

  describe "run/1" do
    test "it identifies drugs in the AST" do
      assert analyse_test_file("drugs.pml").drugs ==
        [
          %{label: "cocaine", line: 17},
          %{label: "paracetamol", line: 8}
        ]
    end

    test "it identifies unnamed constructs in the AST" do
      assert analyse_test_file("unnamed.pml").unnamed == [%{type: :task, line: 2}]
    end

    test "it identifies construct name clashes in the AST" do
      assert analyse_test_file("clashes.pml").clashes ==
        [
          %{
            name: "baz",
            occurrences: [
              %{line: 9, type: :action},
              %{line: 3, type: :action}
            ],
          },
          %{
            name: "baz2",
            occurrences: [
              %{line: 7, type: :action},
              %{line: 5, type: :action}
            ],
          }
        ]
    end
  end
end
