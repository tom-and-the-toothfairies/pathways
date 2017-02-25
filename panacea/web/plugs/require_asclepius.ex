defmodule Panacea.Plugs.RequireAsclepius do
  alias Panacea.Asclepius
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if Asclepius.ready? do
      conn
    else
      conn
      |> send_resp(:service_unavailable, "Asclepius is unavailable.")
      |> halt()
    end
  end
end
