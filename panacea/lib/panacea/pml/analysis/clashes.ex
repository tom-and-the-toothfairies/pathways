defmodule Panacea.Pml.Analysis.Clashes do
  @composite [:task, :sequence, :branch, :selection, :iteration, :action, :process]

  def run(ast) do
    analyse(%{}, ast)
    |> Enum.filter_map(fn {_, occurrences} ->
      length(occurrences) > 1
    end,
    fn {name, occurrences} ->
      %{name: to_string(name), occurrences: occurrences}
    end)
  end

  defp analyse(result, {type, attrs, children}) when type in @composite do
    result =
      case Keyword.get(attrs, :name) do
        nil ->
          result
        name ->
          occurrence = %{type: type, line: Keyword.get(attrs, :line)}
          Map.update(result, name, [occurrence], fn occurrences ->
            [occurrence | occurrences]
          end)
      end

    Enum.reduce(children, result, fn (child, acc) ->
      analyse(acc, child)
    end)
  end
  defp analyse(result, _), do: result
end
