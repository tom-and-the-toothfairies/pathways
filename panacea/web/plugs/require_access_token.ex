defmodule Panacea.Plugs.RequireAccessToken do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> fetch_auth_header()
    |> verify_token()
  end

  defp fetch_auth_header(conn) do
    case get_req_header(conn, "authorization") do
      [] ->
        conn
        |> send_resp(:forbidden, "access token missing")
        |> halt()

      [token] ->
        conn
        |> assign(:access_token, token)
    end
  end

  defp verify_token(%Plug.Conn{halted: true} = conn), do: conn
  defp verify_token(conn) do
    if Panacea.AccessToken.verify(conn.assigns[:access_token]) do
      conn
    else
      conn
      |> send_resp(:forbidden, "invalid access token")
      |> halt()
    end
  end
end
