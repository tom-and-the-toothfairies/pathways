defmodule Panacea.Asclepius do
  @name __MODULE__

  def ready? do
    Agent.get(@name, &(&1))
  end

  def set_readiness(readiness) do
    Agent.update(@name, fn _ -> readiness end)
  end

  # Agent API

  def start_link do
    Agent.start_link(fn -> false end, name: @name)
  end
end
