defmodule Panacea.Pml.Analysis.Duplicate do
  @composite [:task, :sequence, :branch, :selection, :iteration, :action, :process]

  def testrun do
    ast = File.read!("test/fixtures/duplicate_names.pml")
    |> Panacea.Pml.Parser.parse
    |> elem(1)
    ast |> run
  end

  def run(ast) do
    analyse([], ast)
    |> dedup_names
    |> Map.to_list
    |> Enum.filter(fn {_name, xs} -> length(xs) > 1 end)
    |> Enum.map(fn {name, xs} -> %{name: name, lines: xs} end)
  end

  defp analyse(result, {type, attrs, children}) when type in @composite do
    result =
      if Keyword.has_key?(attrs, :name) do
        [%{name: Keyword.get(attrs, :name),
           line: Keyword.get(attrs, :line)} | result]
      else
        result
      end

    Enum.reduce(children, result, fn (child, acc) ->
      analyse(acc, child)
    end)
  end
  defp analyse(result, {_, _, child}) do
    analyse(result, child)
  end
  defp analyse(result, _), do: result

  defp dedup_names(list) do
    dedup_names(list, %{})
  end
  defp dedup_names([%{name: name, line: line} | rest], seen_names) do
    if Map.has_key?(seen_names, name) do
      dedup_names(rest, %{seen_names | name => [line | seen_names[name]]})
    else
      dedup_names(rest, Map.put(seen_names, name, [line]))
    end
  end
  defp dedup_names([], seen_names), do: seen_names
end
