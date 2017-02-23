defmodule Panacea.Asclepius.HealthChecker do
  alias Panacea.Asclepius
  use GenServer
  require Logger

  @name __MODULE__
  @check_interval 5000

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    schedule_check()
    {:ok, :no_response}
  end

  def handle_info(:check_health, :ok), do: {:noreply, :ok}
  def handle_info(:check_health, _) do
    health = check_health()
    update_readiness(health)
    schedule_check()
    {:noreply, health}
  end

  defp check_health() do
    Logger.info("Pinging Asclepius")
    {health, _} = Asclepius.Remote.ping()
    health
  end

  defp update_readiness(:ok) do
    Logger.info("Asclepius is ready.")
    Asclepius.set_readiness(true)
  end
  defp update_readiness(_), do: Logger.info("Asclepius is not responding.")

  defp schedule_check do
    Process.send_after(self(), :check_health, @check_interval)
  end
end
