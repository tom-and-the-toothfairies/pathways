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
    uris_to_labels = Enum.into(drugs, %{}, fn %{"uri" => uri, "label" => label} ->
      {uri, label}
    end)

    Enum.map(ddis, fn ddi ->
      label_a = uris_to_labels[ddi["drug_a"]]
      label_b = uris_to_labels[ddi["drug_b"]]

      ancestries_a = Map.get(ancestries, label_a, [])
      ancestries_b = Map.get(ancestries, label_b, [])

      for {ancestry_a, line_a} <- ancestries_a, {ancestry_b, line_b} <- ancestries_b do
        ddi
        |> categorize_ddi(ancestry_a, ancestry_b)
        |> add_drug_metadata(label_a, line_a, label_b, line_b)
      end
    end)
    |> List.flatten()
  end

  defp categorize_ddi(ddi, ancestry_a, ancestry_b) do
     set_a = ancestry_a |> MapSet.new()
     set_b = ancestry_b |> MapSet.new()

     common_ancestors = MapSet.intersection(set_a, set_b)
     closest_common_ancestor = Enum.max_by(common_ancestors, fn {_, _, id} -> id end)
     {category, enclosing_constructs} = analyse_ancestors(closest_common_ancestor, common_ancestors)

     ddi
     |> Map.put("category", category)
     |> Map.put("enclosing_constructs", enclosing_constructs)
  end

  defp add_drug_metadata(ddi, label_a, line_a, label_b, line_b) do
    drug_a = %{
      "uri" => ddi["drug_a"],
      "label" => label_a,
      "line" => line_a
    }
    drug_b = %{
      "uri" => ddi["drug_b"],
      "label" => label_b,
      "line" => line_b
    }

    ddi
    |> Map.put("drug_a", drug_a)
    |> Map.put("drug_b", drug_b)
  end

  defp analyse_ancestors({:branch, line, _}, _) do
    {:parallel, [%{"type" => :branch, "line" => line}]}
  end
  defp analyse_ancestors({:selection, line, inner_id}, ancestors) do
    inner = %{"type" => :selection, "line" => line}
    sorted_ancestors = Enum.sort(ancestors, fn({_,_,id_a},{_,_,id_b}) ->
      id_a >= id_b
    end)

    case Enum.find(sorted_ancestors, fn {type, _, id} -> type == :iteration && id < inner_id end) do
      nil ->
        {:alternative, [inner]}
      {:iteration, line, _} ->
        {:repeated_alternative, [inner, %{"type" => :iteration, "line" => line}]}
    end
  end
  defp analyse_ancestors({type, line, _}, _) do
    {:sequential, [%{"type" => type, "line" => line}]}
  end

  defp build_ancestries(ast), do: do_build_ancestries(ast, [], %{id: 0})

  defp do_build_ancestries({type, attrs, children}, ancestors, acc) when type in @composite_constructs do
    line =  Keyword.get(attrs, :line)
    new_ancestors = [{type, line, acc.id}|ancestors]

    Enum.reduce(children, acc, fn (child, a) ->
      do_build_ancestries(child, new_ancestors, %{a|id: a.id + 1})
    end)
  end
  defp do_build_ancestries({:requires, _, {:drug, [line: line], label}}, ancestors, acc) do
    key = Util.strip_quotes(label)
    value = {ancestors, line}
    Map.update(acc, key, [value], fn ancestries ->
      [value|ancestries]
    end)
  end
  defp do_build_ancestries(_, _, acc), do: acc
end
