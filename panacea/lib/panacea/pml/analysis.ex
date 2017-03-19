defmodule Panacea.Pml.Analysis do
  alias __MODULE__
  alias Panacea.Pml.Analysis.{Drugs, Unnamed}

  defstruct [:drugs, :unnamed, :ast]

  def run(ast) do
    drugs = Drugs.run(ast)
    unnamed = Unnamed.run(ast)

    encoded_ast =
      ast
      |> :erlang.term_to_binary()
      |> Base.encode64()

    {:ok, %Analysis{drugs: drugs, unnamed: unnamed, ast: encoded_ast}}
  end
end
