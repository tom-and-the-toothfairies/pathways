defmodule Panacea.Asclepius.Remote do
  @type dinto_uri :: String.t
  @type label     :: String.t
  @type reason    :: any
  @type response  :: any

  @callback ddis([dinto_uri])        :: {:ok, response} | {:error, reason}
  @callback uris_for_labels([label]) :: {:ok, response} | {:error, reason}
end
