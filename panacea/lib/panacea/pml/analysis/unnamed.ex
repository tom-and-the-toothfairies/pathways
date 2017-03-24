defmodule Panacea.Pml.Analysis.Unnamed do
  @composite_constructs Application.get_env(:panacea, :composite_pml_constructs)

  def run(ast) do
    analyse([], ast)
  end

  defp analyse(result, {type, attrs, children}) when type in @composite_constructs do
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
