defmodule Panacea.AccessToken do
  # arbitraty TTL for tokens - 6 hours
  @ttl 60 * 60 * 6

  def generate do
    Phoenix.Token.sign(Panacea.Endpoint, "access-token", nil)
  end

  def verify(token) do
    {status, _} = Phoenix.Token.verify(
      Panacea.Endpoint,
      "access-token",
      token,
      max_age: @ttl
    )

    status == :ok
  end
end
