defmodule Panacea.Pml.Ast do
  @multi_line_constructs ~w(process action task sequence selection branch iteration)a
  @single_line_constructs ~w(requires provides agent tool script input output)a

  @doc """
  Takes an AST and returns the PML it represents in an IO-List
  """
  def to_pml(ast) do
    do_unquote(ast, 0)
  end

  defp do_unquote({type, attrs, children}, depth) when type in @multi_line_constructs do
    optional_name = get_with_default(attrs, :name)
    optional_type = get_with_default(attrs, :type)

    [indent(depth), to_string(type), optional_name, optional_type, " {\n",
     Enum.map(children, fn(child) -> [do_unquote(child, depth + 1), "\n"] end),
     indent(depth), "}"
    ]
  end

  defp do_unquote({type, _, value}, depth) when type in @single_line_constructs do
    [indent(depth), to_string(type), " { ", do_unquote(value), " }"]
  end

  defp do_unquote({:expression, _, value}), do: value
  defp do_unquote({:drug, _, value}), do: ["drug { ", value, " }"]
  defp do_unquote(x) when is_list(x), do: x

  defp indent(depth), do: String.duplicate(" ", 2 * depth)

  defp get_with_default(attrs, key) do
    case Keyword.get(attrs, key) do
      nil -> ""
      x   -> [" ", x]
    end
  end
end
