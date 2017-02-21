defmodule Panacea.Pml.ParserTest do
  use ExUnit.Case, async: true
  alias Panacea.Pml.Parser

  @root_dir File.cwd!
  @fixtures_dir Path.join(~w(#{@root_dir} test fixtures))

  describe "parse/1" do
    test "it parses correct pml" do
      pml = """
      process foo {
        task bar {
          action baz {
            tool { "drill" }
            script { "drill a hole" }
            agent { "driller" }
            requires { "wall" }
            provides { "a hole" }
          }
        }
      }
      """

      assert Parser.parse(pml) == {:ok, []}
    end

    test "it can parse all of jnoll's sample pml" do
      {:ok, files} = File.ls(@fixtures_dir)
      for file <-  files do
        {:ok, pml} = Path.join(@fixtures_dir, file) |> File.read()
        {status, possible_error} = Parser.parse(pml)

        assert status == :ok, "failed to parse file: #{file} -- error: #{inspect possible_error}"
      end
    end

    test "it rejects incorrect pml" do
      pml = """
      process foo {{
      """

      assert Parser.parse(pml) == {:error,  "line 1 -- syntax error before: '{'"}
    end

    test "it identifies drugs" do
      pml = """
        process foo {
          task bar {
            action baz {
              tool { "pills" }
              script { "eat the pills" }
              agent { "patient" }
              requires { "chebi:1234" }
              provides { "a cured patient" }
            }
            action baz2 {
              tool { "pills" }
              script { "eat the pills" }
              agent { "patient" }
              requires { "dinto:1234" }
              provides { "a cured patient" }
            }
          }
        }
      """

      assert Parser.parse(pml) == {:ok, ["chebi:1234","dinto:1234"]}
    end
  end
end
