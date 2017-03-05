defmodule Panacea.Asclepius.Remote.Mock do
  @behaviour Panacea.Asclepius.Remote

  def ddis(_drugs) do
    {:ok,
     [
        %{
          "drug_a" => "chebi:421707",
          "drug_b" => "chebi:465284",
          "label" => "abacavir/ganciclovir DDI",
          "uri" => "http://purl.obolibrary.org/obo/DINTO_05759"
        },
        %{
          "drug_a" => "chebi:421707",
          "drug_b" => "dinto:DB00503",
          "label" => "abacavir/ritonavir DDI",
          "uri" => "http://purl.obolibrary.org/obo/DINTO_11043"
        }
      ]
    }
  end
end
