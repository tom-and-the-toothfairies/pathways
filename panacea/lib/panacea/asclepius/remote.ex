defmodule Panacea.Asclepius.Remote do
  @type drug     :: String.t
  @type reason   :: any
  @type response :: any

  @callback ddis([drug]) :: {:ok, response} | {:error, reason}
end
