defmodule Panacea.Pml.Analysis.DdisTest do
  alias Panacea.Pml.Analysis
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
    test "it categorizes sequential DDIs correctly" do
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

      assert Analysis.Ddis.run(ast, test_ddis(), test_drugs()) == [
        %{
          "category" => :sequential,
          "drug_a" => "http://purl.com/paracetamol",
          "drug_b" => "http://purl.com/cocaine",
          "enclosing_construct" => %{
            "type" => :process,
            "line" => 1
          }
        }
      ]
    end

    test "it categorizes parallel DDIs correctly" do
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

      assert Analysis.Ddis.run(ast, test_ddis(), test_drugs()) == [
        %{
          "category" => :parallel,
          "drug_a" => "http://purl.com/paracetamol",
          "drug_b" => "http://purl.com/cocaine",
          "enclosing_construct" => %{
            "type" => :branch,
            "line" => 2
          }
        }
      ]
    end

    test "it categorizes alternative DDIs correctly" do
      pml = """
      process alternative_ddis {
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

      assert Analysis.Ddis.run(ast, test_ddis(), test_drugs()) == [
        %{
          "category" => :alternative,
          "drug_a" => "http://purl.com/paracetamol",
          "drug_b" => "http://purl.com/cocaine",
          "enclosing_construct" => %{
            "type" => :selection,
            "line" => 2
          }
        }
      ]
    end

    test "it can handle more complicated PML" do
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
              requires { drug { "skittles" } }
            }
          }
        }
      }
      """
      ddis = [
        %{"drug_a" => "http://purl.com/paracetamol", "drug_b" => "http://purl.com/cocaine"},
        %{"drug_a" => "http://purl.com/cocaine", "drug_b" => "http://purl.com/flat_seven_up"},
        %{"drug_a" => "http://purl.com/heroin", "drug_b" => "http://purl.com/skittles"}
      ]
      drugs = [
        %{"label" => "paracetamol", "uri" => "http://purl.com/paracetamol"},
        %{"label" => "cocaine", "uri" => "http://purl.com/cocaine"},
        %{"label" => "flat seven up", "uri" => "http://purl.com/flat_seven_up"},
        %{"label" => "heroin", "uri" => "http://purl.com/heroin"},
        %{"label" => "skittles", "uri" => "http://purl.com/skittles"},
      ]
      ast = parse_pml(pml)

      assert Analysis.Ddis.run(ast, ddis, drugs) == [
        %{
          "category" => :alternative,
          "drug_a" => "http://purl.com/paracetamol",
          "drug_b" => "http://purl.com/cocaine",
          "enclosing_construct" => %{
            "type" => :selection,
            "line" => 2
          }
        },
        %{
          "category" => :parallel,
          "drug_a" => "http://purl.com/cocaine",
          "drug_b" => "http://purl.com/flat_seven_up",
          "enclosing_construct" => %{
            "type" => :branch,
            "line" => 6
          }
        },
        %{
          "category" => :sequential,
          "drug_a" => "http://purl.com/heroin",
          "drug_b" => "http://purl.com/skittles",
          "enclosing_construct" => %{
            "type" => :sequence,
            "line" => 14
          }
        }
      ]
    end
  end
end
