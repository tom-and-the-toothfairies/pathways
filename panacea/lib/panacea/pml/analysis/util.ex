defmodule Panacea.Pml.Analysis.Util do
  def strip_quotes(char_list) do
    char_list
    |> :string.strip(:both, ?")
    |> to_string()
  end
end
