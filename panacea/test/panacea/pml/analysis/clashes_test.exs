defmodule Panacea.Pml.Analysis.ClashesTest do
  use ExUnit.Case

  @fixtures_dir "test/fixtures/analysis"

  describe "run/1" do
    test "identifies construct name clashes in the AST" do
      {:ok, pml} = Path.join(@fixtures_dir, "clashes.pml") |> File.read()

      {:ok, ast} = Panacea.Pml.Parser.parse(pml)
      clashes = Panacea.Pml.Analysis.Clashes.run(ast)

      assert clashes ==
        [
          %{
            name: "clash1",
            occurrences: [
              %{line: 9, type: :action},
              %{line: 2, type: :action}
            ]
          },
          %{
            name: "clash2",
            occurrences: [
              %{line: 7, type: :action},
              %{line: 5, type: :action}
            ]
          }
        ]
    end
  end
end
