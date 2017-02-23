defmodule Panacea.Asclepius.Remote.Mock do
  @behaviour Panacea.Asclepius.Remote

  def ping(), do: {:ok, nil}
  def ddis(_drugs) do
    [
      %{
        "label" => "tranylcypromine/vilazodone DDI",
        "uri" => "http://purl.obolibrary.org/obo/DINTO_08338"
      },
      %{
        "label" => "penbutolol/methysergide DDI",
        "uri" => "http://purl.obolibrary.org/obo/DINTO_07540"
      },
      %{
        "label" => "drospirenone/heparin DDI",
        "uri" => "http://purl.obolibrary.org/obo/DINTO_03086"
      }
    ]
  end
end
