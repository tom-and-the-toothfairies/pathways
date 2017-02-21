defmodule Panacea do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Panacea.Endpoint, []),
      supervisor(Panacea.Asclepius.Supervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Panacea.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Panacea.Endpoint.config_change(changed, removed)
    :ok
  end
end
