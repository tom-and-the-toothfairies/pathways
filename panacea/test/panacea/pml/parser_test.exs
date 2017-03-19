defmodule Panacea.Pml.ParserTest do
  use ExUnit.Case, async: true
  alias Panacea.Pml.Parser

  @root_dir File.cwd!
  @fixtures_dir Path.join(~w(#{@root_dir} test fixtures jnolls_pml))

  describe "parse/1" do
    test "it parses correct pml" do
      pml = """
      process foo {
        task bar {
          action baz {
            tool { "drill" }
            script { "drill a hole" }
            agent { 44.1234532E-123342 }
            requires { "wall" }
            provides { "a hole" }
          }
        }
      }
      """

      assert {:ok, _} = Parser.parse(pml)
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

      assert Parser.parse(pml) == {:error,  {:syntax_error, "line 1 -- syntax error before: '{'"}}
    end
  end
end
