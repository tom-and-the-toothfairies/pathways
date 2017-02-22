defmodule Panacea.Asclepius.HealthChecker do
  alias Panacea.Asclepius
  use GenServer
  require Logger

  @name __MODULE__
  @check_interval 5000
  @options [recv_timeout: 50]

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    schedule_check()
    {:ok, false}
  end

  def handle_info(:check_health, true), do: {:noreply, true}
  def handle_info(:check_health, _) do
    health = check_health()
    update_readiness(health)
    schedule_check()
    {:noreply, health}
  end

  defp check_health() do
    Logger.info("Pinging Asclepius")
    case HTTPoison.get(asclepius_uri(), @options) do
      {:ok, _} ->
        Logger.info("Asclepius is up")
        true
      _ ->
        Logger.info("Asclepius is down")
        false
    end
  end

  defp asclepius_uri do
    [host: host, port: port] = Application.get_env(:panacea, :asclepius)
    "http://#{host}:#{port}/ping"
  end

  defp update_readiness(true), do: Asclepius.set_readiness(true)
  defp update_readiness(_), do: nil

  defp schedule_check do
    Process.send_after(self(), :check_health, @check_interval)
  end
end
