defmodule Panacea.Asclepius do
  @asclepius_api Keyword.get(Application.get_env(:panacea, :asclepius), :api)

  def ddis(drugs) when is_list(drugs) and length(drugs) >= 2 do
    @asclepius_api.ddis(drugs)
  end
  def ddis(drugs) do
    message = "expected a list 2 or more drugs - got #{inspect drugs}"
    {:error, {:invalid_data, message}}
  end

  def uris_for_labels(labels) when is_list(labels) do
    @asclepius_api.uris_for_labels(labels)
  end
  def uris_for_labels(labels) do
    message = "expected a list of drug labels - got #{inspect labels}"
    {:error, {:invalid_data, message}}
  end
end
