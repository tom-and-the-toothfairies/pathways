defmodule Panacea.Pml.AstTest do
  use ExUnit.Case

  describe "to_pml/2" do
    test "it returns the correct PML" do
      pml = """
      process foo {
        task bar {
          action baz {
            tool { "pills" }
            script { "eat the pills" }
            agent { "patient" }
            requires { drug { "torasemide" } }
            provides { "a cured patient" }
          }
          action baz2 {
            tool { "pills" }
            script { "eat the pills" }
            agent { (intangible) (inscrutable) pml.wtf && ("foo" || 1 != 2) }
            requires { drug { "trandolapril" } }
            provides { "a cured patient" }
          }
        }
      }
      """
      |> String.replace_trailing("\n", "")

      {:ok, ast} = Panacea.Pml.Parser.parse(pml)
      generated_pml = Panacea.Pml.Ast.to_pml(ast) |> IO.chardata_to_string()

      assert generated_pml == pml
    end
  end
end
