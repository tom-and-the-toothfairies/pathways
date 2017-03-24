defmodule Panacea.Pml.Ast do
  @multi_line_constructs ~w(process action task sequence selection branch iteration)a
  @single_line_constructs ~w(requires provides agent tool script input output)a

  @doc """
  Takes an AST and returns the PML it represents in an IO-List
  """
  def to_pml(ast) do
    do_unquote(ast, 0)
  end

  def decode(ast) do
    ast
    |> decode64()
    |> to_erlang_term()
  end

  defp decode64(encoded_ast) do
    case Base.decode64(encoded_ast) do
      {:ok, binary} ->
        {:ok, binary}
      :error ->
        {:error, {:encoding_error, "AST is not base64 encoded."}}
    end
  end

  defp to_erlang_term({:ok, binary}) do
    {:ok, :erlang.binary_to_term(binary)}
  end
  defp to_erlang_term({:error, reason}) do
    {:error, reason}
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
