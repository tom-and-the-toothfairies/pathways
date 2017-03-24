defmodule Panacea.Pml.Analysis.Ddis do
  alias Panacea.Pml.Analysis.Util
  @composite_constructs Application.get_env(:panacea, :composite_pml_constructs)

  def run(_, [], _), do: []
  def run(ast, ddis, drugs) do
    ast
    |> build_ancestries()
    |> categorize_ddis(ddis, drugs)
  end

  defp categorize_ddis(ancestries, ddis, drugs) do
    uris_to_labels = Enum.into(drugs, %{}, fn %{uri: uri, label: label} ->
      {uri, label}
    end)

    Enum.map(ddis, fn ddi ->
      drug_a = uris_to_labels[ddi.drug_a]
      drug_b = uris_to_labels[ddi.drug_b]

      ancestors_a = Map.get(ancestries, drug_a, []) |> MapSet.new()
      ancestors_b = Map.get(ancestries, drug_b, []) |> MapSet.new()

      Map.put(ddi, :type, categorize_ddi(ancestors_a, ancestors_b))
    end)
  end

  defp categorize_ddi(ancestors_a, ancestors_b) do
     closest_common_ancestor =
       MapSet.intersection(ancestors_a, ancestors_b)
       |> Enum.max_by(fn {_, _, id} -> id end)

     case closest_common_ancestor do
       {:branch, _, _} ->
         :parallel
       {:selection, _, _} ->
         :alternative
       _ ->
         :sequential
     end
  end

  defp build_ancestries(ast), do: do_build_ancestries(ast, [], %{id: 0})

  defp do_build_ancestries({type, attrs, children}, ancestors, acc) when type in @composite_constructs do
    line =  Keyword.get(attrs, :line)
    new_ancestors = [{type, line, acc.id}|ancestors]

    Enum.reduce(children, acc, fn (child, a) ->
      do_build_ancestries(child, new_ancestors, %{a|id: a.id + 1})
    end)
  end
  defp do_build_ancestries({:requires, _, {:drug, _, label}}, ancestors, acc) do
    Map.put(acc, Util.strip_quotes(label), ancestors)
  end
end
