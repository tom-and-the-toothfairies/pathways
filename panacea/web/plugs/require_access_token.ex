defmodule Panacea.Plugs.RequireAccessToken do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> fetch_auth_token_from_headers()
    |> fetch_query_params()
    |> fetch_auth_token_from_url()
    |> verify_token()
  end

  defp fetch_auth_token_from_headers(conn) do
    case get_req_header(conn, "authorization") do
      [] ->
        conn

      [token] ->
        conn
        |> assign(:access_token, token)
    end
  end

  defp fetch_auth_token_from_url(conn) do
    case conn.params do
      %{"authorization_token" => token} ->
        conn
        |> assign(:access_token, token)
      _ ->
        conn
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
