defmodule Panacea.Pml.AnalysisTest do
  use ExUnit.Case

  describe "run/1" do
    test "it identifies drugs in the AST" do
      pml = """
      process foo {
        task bar {
          action baz {
            tool { "pills" }
            script { "eat the pills" }
            agent { "patient" }
            requires {
              drug { "paracetamol" }
            }
            provides { "a cured patient" }
          }
          action baz2 {
            tool { "pills" }
            script { "eat the pills" }
            agent { "patient" }
            requires {
              drug { "cocaine" }
            }
            provides { "a cured patient" }
          }
        }
      }
      """

      {:ok, ast} = Panacea.Pml.Parser.parse(pml)
      {:ok, analysis} = Panacea.Pml.Analysis.run(ast)

      assert analysis.drugs ==
        [
          %{label: "cocaine", line: 17},
          %{label: "paracetamol", line: 8}
        ]
    end
  end
end
