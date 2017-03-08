defmodule Panacea.Asclepius.Remote.Mock do
  @behaviour Panacea.Asclepius.Remote

  def ddis(_drugs) do
    {:ok,
     [
       %{
         "drug_a" => "http://purl.obolibrary.org/obo/DINTO_DB00214",
         "drug_b" => "http://purl.obolibrary.org/obo/DINTO_DB00519",
         "label" => "torasemide/trandolapril DDI",
         "uri"   => "http://purl.obolibrary.org/obo/DINTO_11031"
       }
     ]
    }
  end

  def uris_for_labels(_labels) do
    {:ok,
     %{
       "found" => %{
         "http://purl.obolibrary.org/obo/CHEBI_27958" => "cocaine",
         "http://purl.obolibrary.org/obo/CHEBI_46195" => "paracetamol",

       },
       "not_found" => [
         "flat seven up"
       ]
     }
    }
  end
end
