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
      drug_a = uris_to_labels[ddi["drug_a"]]
      drug_b = uris_to_labels[ddi["drug_b"]]

      ancestries_a = Map.get(ancestries, drug_a, [])
      ancestries_b = Map.get(ancestries, drug_b, [])

      for ancestry_a <- ancestries_a, ancestry_b <- ancestries_b do
        categorize_ddi(ddi, ancestry_a, ancestry_b)
      end
    end)
    |> List.flatten()
  end

  defp categorize_ddi(ddi, ancestry_a, ancestry_b) do
     set_a = ancestry_a |> MapSet.new()
     set_b = ancestry_b |> MapSet.new()

     {construct_type, line, _} =
       MapSet.intersection(set_a, set_b)
       |> Enum.max_by(fn {_, _, id} -> id end)

     ddi
     |> Map.put("category", category_for_construct(construct_type))
     |> Map.put("enclosing_construct", %{"type" => construct_type, "line" => line})
  end

  defp category_for_construct(:branch),    do: :parallel
  defp category_for_construct(:selection), do: :alternative
  defp category_for_construct(_),          do: :sequential

  defp build_ancestries(ast), do: do_build_ancestries(ast, [], %{id: 0})

  defp do_build_ancestries({type, attrs, children}, ancestors, acc) when type in @composite_constructs do
    line =  Keyword.get(attrs, :line)
    new_ancestors = [{type, line, acc.id}|ancestors]

    Enum.reduce(children, acc, fn (child, a) ->
      do_build_ancestries(child, new_ancestors, %{a|id: a.id + 1})
    end)
  end
  defp do_build_ancestries({:requires, _, {:drug, _, label}}, ancestors, acc) do
    key = Util.strip_quotes(label)
    Map.update(acc, key, [ancestors], fn ancestries ->
      [ancestors|ancestries]
    end)
  end
  defp do_build_ancestries(_, _, acc), do: acc
end
