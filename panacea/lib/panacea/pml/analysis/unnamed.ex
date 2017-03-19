defmodule Panacea.Pml.Analysis.Unnamed do

  @composite [:task, :sequence, :branch, :selection, :iteration, :action, :process]

  def run(ast) do
    analyse([], ast)
  end

  defp analyse(result, {type, attrs, children}) when type in @composite do
    result =
      if !Keyword.has_key?(attrs, :name) do
        [%{type: type, line: Keyword.get(attrs, :line)} | result]
      else
        result
      end

    Enum.reduce(children, result, fn (child, acc) ->
      analyse(acc, child)
    end)
  end
  defp analyse(result, _), do: result
end
