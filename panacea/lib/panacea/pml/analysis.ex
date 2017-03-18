defmodule Panacea.Pml.Analysis do
  alias __MODULE__
  alias Panacea.Pml.Analysis.{Drugs, Unnamed}

  defstruct drugs: [], unnamed: []

  def run(ast) do
    drugs = Drugs.run(ast)
    unnamed = Unnamed.run(ast)

    {:ok, %Analysis{drugs: drugs, unnamed: unnamed}}
  end
end
