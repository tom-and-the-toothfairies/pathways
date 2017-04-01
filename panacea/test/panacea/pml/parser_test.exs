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

      assert Parser.parse(pml) == { :error,
        {
          :syntax_error,
          "line 1 -- syntax error before: '{'",
          %{line: 1}
        }
      }
    end
  end

  describe "time validations" do
    test "it parses valid times" do
      pml = """
      process foo {
        action bar {
          requires {
            time {
              years { 10 }
              days { 120 }
              hours { 12 }
              minutes { 44 }
            }
          }
        }
      }
      """

      assert {:ok, _} = Parser.parse(pml)
    end

    test "it rejects out of range times" do
      bad_times = [
        {"minutes", 60},
        {"hours", 24},
        {"days", 365},
        {"years", 100}
      ]

      for {unit, value} <- bad_times do
        pml = """
        process foo {
          action bar {
            requires {
              time {
                #{unit} { #{value} }
              }
            }
          }
        }
        """

        {status, result} = Parser.parse(pml)
        message = "line 5 -- '#{unit}' cannot be more than #{value - 1} (was #{value})"

        assert status == :error
        assert result == {:syntax_error, message, %{line: 5}}
      end
    end

    test "it rejects repeated times" do
      pml = """
      process foo {
        action bar {
          requires {
            time {
              years { 4 }
              years { 4 }
            }
          }
        }
      }
      """

      {status, result} = Parser.parse(pml)
      message = "line 6 -- 'years' used more than once"

      assert status == :error
      assert result == {:syntax_error, message, %{line: 6}}
    end

    test "it rejects non-integer times" do
      pml = """
      process foo {
        action bar {
          requires {
            time {
              years { 4.5 }
            }
          }
        }
      }
      """

      {status, result} = Parser.parse(pml)
      message = "line 5 -- syntax error before: 4.5"

      assert status == :error
      assert result == {:syntax_error, message, %{line: 5}}
    end
  end
end
