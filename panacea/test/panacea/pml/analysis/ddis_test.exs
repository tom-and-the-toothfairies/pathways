defmodule Panacea.Pml.Analysis.DdisTest do
  alias Panacea.Pml.Analysis.Ddis
  use ExUnit.Case

  defp parse_pml(pml) do
    {:ok, ast} = Panacea.Pml.Parser.parse(pml)
    ast
  end

  def test_ddis() do
    [
      %{"drug_a" => "http://purl.com/paracetamol", "drug_b" => "http://purl.com/cocaine"}
    ]
  end

  def test_drugs() do
    [
      %{"label" => "paracetamol", "uri" => "http://purl.com/paracetamol"},
      %{"label" => "cocaine", "uri" => "http://purl.com/cocaine"},
    ]
  end

  describe "run/2" do
    test "it categorizes Sequential DDIs correctly" do
      pml = """
      process sequential_ddis {
        action s1 {
          requires { drug { "paracetamol" } }
        }
        action s2 {
          requires { drug { "cocaine" } }
        }
      }
      """
      ast = parse_pml(pml)
      [%{"category" => category}] = Ddis.run(ast, test_ddis(), test_drugs())
      assert category == :sequential
    end

    test "it categorizes Parallel DDIs correctly" do
      pml = """
      process parallel_ddis {
        branch {
          action b1 {
            requires { drug { "paracetamol" } }
          }
          action b2 {
            requires { drug { "cocaine" } }
          }
        }
      }
      """
      ast = parse_pml(pml)
      [%{"category" => category}] = Ddis.run(ast, test_ddis(), test_drugs())

      assert category == :parallel
    end

    test "it categorizes Alternative non-DDIs correctly" do
      pml = """
      process alternative_non_ddis {
        selection {
          action s1 {
            requires { drug { "paracetamol" } }
          }
          action s2 {
            requires { drug { "cocaine" } }
          }
        }
      }
      """
      ast = parse_pml(pml)
      [%{"category" => category}] = Ddis.run(ast, test_ddis(), test_drugs())

      assert category == :alternative
    end

    test "it categorizes Repeated Alternative DDIs correctly" do
      pml = """
      process repeated_alternative_ddis {
        iteration {
          selection {
            action s1 {
              requires { drug { "paracetamol" } }
            }
            action s2 {
              requires { drug { "cocaine" } }
            }
          }
        }
      }
      """
      ast = parse_pml(pml)
      [%{"category" => category}] = Ddis.run(ast, test_ddis(), test_drugs())

      assert category == :repeated_alternative
    end

    test "it can handle repeated drugs" do
      pml = """
      process repeated_drugs {
        selection {
          action s1 {
            requires { drug { "paracetamol" } }
          }
          action s2 {
            requires { drug { "cocaine" } }
          }
          action s3 {
            requires { drug { "paracetamol" } }
          }
        }
      }
      """

      ast = parse_pml(pml)
      ddis = Ddis.run(ast, test_ddis(), test_drugs())

      assert ddis |> Enum.count() == 2
    end

    test "it adds the correct DDI metadata" do
      pml = """
      process repeated_alternative_ddis {
        iteration {
          selection {
            action s1 {
              requires { drug { "paracetamol" } }
            }
            action s2 {
              requires { drug { "cocaine" } }
            }
          }
        }
      }
      """
      ast = parse_pml(pml)
      [ddi] = Ddis.run(ast, test_ddis(), test_drugs())

      assert ddi["category"] == :repeated_alternative

      assert ddi["drug_a"] == %{
        "uri" => "http://purl.com/paracetamol",
        "label" => "paracetamol",
        "line" => 5
      }

      assert ddi["drug_b"] == %{
        "uri" => "http://purl.com/cocaine",
        "label" => "cocaine",
        "line" => 8
      }

      assert ddi["enclosing_constructs"] == [
        %{ "type" => :selection, "line" => 3 },
        %{ "type" => :iteration, "line" => 2 }
      ]
    end
  end
end
