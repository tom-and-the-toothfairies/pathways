defmodule Panacea.Pml.Analysis do
  alias __MODULE__

  defstruct drugs: []

  def run(ast) do
    {:ok, analyse(%Analysis{}, ast)}
  end

  defp analyse(result, {:drug, [line: line], label}) do
    %{result| drugs: [ %{label: to_string(label), line: line}| result.drugs ]}
  end
  defp analyse(result, {_, _,children}) when is_list(children) do
    Enum.reduce(children, result, fn(child, acc) ->
      analyse(acc, child)
    end)
  end
  defp analyse(result, {_, _,child}) do
    analyse(result, child)
  end
  defp analyse(result, _), do: result

  def test do
    {:ok, ast} = Panacea.Pml.Parser.test
    run(ast)
  end
end
