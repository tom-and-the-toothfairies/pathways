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

      assert Parser.parse(pml) ==
        {:ok, {:process, [{:task, [{:action, [:tool, :script, :agent, :requires, :provides]}]}]}}
    end

    test "it can parse all of jnoll's sample pml" do
      {:ok, files} = File.ls(@fixtures_dir)
      for file <-  files do
        {:ok, pml} = Path.join(@fixtures_dir, file) |> File.read()

        {status, possible_error} = Parser.parse(pml)

        assert status == :ok, "failed to parse #{file}. error: #{inspect possible_error}"
      end
    end

    test "it rejects incorrect pml" do
      pml = """
      process foo {
      """

      assert {:error, {1, :pml_parser, _}} = Parser.parse(pml)
    end
  end
end
