defmodule Panacea.Pml.Analysis.DdisTest do
  alias Panacea.Pml.Analysis
  use ExUnit.Case

  defp test_ast() do
    pml = """
    process proc {
      selection {
        action bar {
          requires { drug { "paracetamol" } }
        }
        branch {
          action baz {
            requires { drug { "flat seven up" } }
          }
          action foo {
            requires { drug { "cocaine" } }
          }
        }
        sequence {
           action s1 {
             requires { drug { "heroin" } }
           }
           action s2 {
             requires { drug { "skittles" }}
           }
        }
      }
    }
    """

    {:ok, ast} = Panacea.Pml.Parser.parse(pml)
    ast
  end

  describe "run/2" do
    test "it categorizes the DDIs correctly" do
      ddis = [
        %{drug_a: "http://purl.com/paracetamol", drug_b: "http://purl.com/cocaine"},
        %{drug_a: "http://purl.com/cocaine", drug_b: "http://purl.com/flat_seven_up"},
        %{drug_a: "http://purl.com/heroin", drug_b: "http://purl.com/skittles"}
      ]
      drugs = [
        %{label: "paracetamol", uri: "http://purl.com/paracetamol"},
        %{label: "cocaine", uri: "http://purl.com/cocaine"},
        %{label: "flat seven up", uri: "http://purl.com/flat_seven_up"},
        %{label: "heroin", uri: "http://purl.com/heroin"},
        %{label: "skittles", uri: "http://purl.com/skittles"},
      ]
      ast = test_ast()

      assert Analysis.Ddis.run(ast, ddis, drugs) == [
        %{type: :alternative, drug_a: "http://purl.com/paracetamol", drug_b: "http://purl.com/cocaine"},
        %{type: :parallel, drug_a: "http://purl.com/cocaine", drug_b: "http://purl.com/flat_seven_up"},
        %{type: :sequential, drug_a: "http://purl.com/heroin", drug_b: "http://purl.com/skittles"}
      ]
    end
  end
end
