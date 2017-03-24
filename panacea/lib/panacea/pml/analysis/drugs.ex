defmodule Panacea.Pml.Analysis.Drugs do
  alias Panacea.Pml.Analysis.Util

  def run(ast) do
    analyse([], ast)
  end

  defp analyse(result, {:requires, _, {:drug, [line: line], label}}) do
    [%{label: Util.strip_quotes(label), line: line} | result]
  end
  defp analyse(result, {_, _, children}) when is_list(children) do
    Enum.reduce(children, result, fn(child, acc) ->
      analyse(acc, child)
    end)
  end
  defp analyse(result, _), do: result
end
