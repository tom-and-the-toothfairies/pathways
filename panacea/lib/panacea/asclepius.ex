defmodule Panacea.Asclepius do
  @asclepius_api Keyword.get(Application.get_env(:panacea, :asclepius), :api)

  def ddis(drugs), do: @asclepius_api.ddis(drugs)
end
