defmodule Panacea.Pml.Analysis do
  alias __MODULE__

  defstruct [:drugs, :ast]

  def new(ast) do
    %Analysis{
      drugs: [],
      ast: ast
    }
  end

  def run(ast) do
    {:ok, analyse(Analysis.new(ast), ast)}
  end

  defp analyse(result, {:drug, [line: line], label}) do
    %{result| drugs: [ %{label: strip_quotes(label), line: line}| result.drugs ]}
  end
  defp analyse(result, {_, _,children}) when is_list(children) do
    Enum.reduce(children, result, fn(child, acc) ->
      analyse(acc, child)
    end)
  end
  defp analyse(result, {_, _,child}) do
    analyse(result, child)
  end
  defp analyse(result, _), do: result

  defp strip_quotes(char_list) do
    char_list
    |> :string.strip(:both, ?")
    |> to_string()
  end
end
