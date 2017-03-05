defmodule Panacea.Pml.Parser.Logger do
  require Logger

  def info(message) do
    if should_log?() do
      Logger.info(message)
    end
  end

  def error(message) do
    if should_log?() do
      Logger.error(message)
    end
  end

  defp should_log?, do: Mix.env in [:prod, :dev]
end
