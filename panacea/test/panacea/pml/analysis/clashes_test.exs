defmodule Panacea.Pml.Analysis.ClashesTest do
  use ExUnit.Case

  @fixtures_dir "test/fixtures"

  describe "run/1" do
    test "identifies construct name clashses in the AST" do
      {:ok, pml} = Path.join(@fixtures_dir, "analysis_test.pml") |> File.read()

      {:ok, ast} = Panacea.Pml.Parser.parse(pml)
      clashes = Panacea.Pml.Analysis.Clashes.run(ast)

      assert clashes ==
        [
          %{
            name: 'baz',
            conflicts: [%{line: 3, type: :action},
                      %{line: 28, type: :action}],
          },
          %{
            name: 'baz2',
            conflicts: [%{line: 12, type: :action},
                      %{line: 21, type: :action}],
          }
        ]
    end
  end
end
