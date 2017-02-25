defmodule Panacea.Asclepius.Remote do
  @type drug     :: String.t
  @type reason   :: any
  @type response :: any

  @callback ping()       :: {:ok, response} | {:error, reason}
  @callback ddis([drug]) :: {:ok, response} | {:error, reason}

  @asclepius_api Keyword.get(Application.get_env(:panacea, :asclepius), :api)

  def ping,        do: @asclepius_api.ping()
  def ddis(drugs), do: @asclepius_api.ddis(drugs)
end
