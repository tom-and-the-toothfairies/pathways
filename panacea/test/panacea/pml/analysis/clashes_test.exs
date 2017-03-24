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
            name: "baz",
            occurrences: [
              %{line: 9, type: :action},
              %{line: 3, type: :action}
            ]
          },
          %{
            name: "baz2",
            occurrences: [
              %{line: 7, type: :action},
              %{line: 5, type: :action}
            ]
          }
        ]
    end
  end
end
