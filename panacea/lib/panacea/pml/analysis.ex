defmodule Panacea.Pml.Analysis do
  alias __MODULE__
  alias Panacea.Pml.Analysis.{Drugs, Unnamed, Clashes}
  defstruct [:ast, :clashes, :drugs, :unnamed]

  def run(ast) do
    encoded_ast = Panacea.Pml.Ast.encode(ast)
    clashes = Clashes.run(ast)
    drugs = Drugs.run(ast)
    unnamed = Unnamed.run(ast)

    analysis = %Analysis{
      ast:     encoded_ast,
      clashes: clashes,
      drugs:   drugs,
      unnamed: unnamed
    }

    {:ok, analysis}
  end
end
