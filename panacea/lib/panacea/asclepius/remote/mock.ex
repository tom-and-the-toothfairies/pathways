defmodule Panacea.Asclepius.Remote.Mock do
  @behaviour Panacea.Asclepius.Remote

  def ddis(_drugs) do
    {:ok, [
      %{
        "label" => "abacavir/ritonavir DDI",
        "uri" => "http://purl.obolibrary.org/obo/DINTO_11043"
      },
      %{
        "label" => "abacavir/ganciclovir DDI",
        "uri" => "http://purl.obolibrary.org/obo/DINTO_05759"
      }
    ]}
  end
end
