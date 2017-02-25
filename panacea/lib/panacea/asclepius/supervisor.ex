defmodule Panacea.Asclepius.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Panacea.Asclepius, []),
      worker(Panacea.Asclepius.HealthChecker, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
