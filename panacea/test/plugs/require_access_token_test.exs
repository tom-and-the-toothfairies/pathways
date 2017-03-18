defmodule Panacea.Plugs.RequireAccessTokenTest do
  use Panacea.ConnCase
  alias Panacea.Plugs.RequireAccessToken

  describe "call/2" do
    test "forbids requests with no authorization token", %{conn: conn} do
      resp = RequireAccessToken.call(conn, [])

      assert resp.status == 403
    end

    test "forbids requests with an invalid authorization header", %{conn: conn} do
      resp =
        conn
        |> put_req_header("authorization", "foo")
        |> RequireAccessToken.call([])

      assert resp.status == 403
    end

    test "permits requests with a valid authorization header", %{conn: conn} do
      authorized_conn =
        conn
        |> put_req_header("authorization", Panacea.AccessToken.generate())
        |> RequireAccessToken.call([])

      refute authorized_conn.halted
    end

    test "forbids requests with an invalid authorization token", %{conn: conn} do
      resp =
        %{conn| query_string: "authorization_token=foo"}
        |> RequireAccessToken.call([])

      assert resp.status == 403
    end

    test "permits requests with a valid url encoded authorization token", %{conn: conn} do
      token = Panacea.AccessToken.generate()
      authorized_conn =
        %{conn| query_string: "authorization_token=#{token}"}
        |> RequireAccessToken.call([])

      refute authorized_conn.halted
    end

    test "when a token is provided in the headers and url, the url wins", %{conn: conn} do
      token = Panacea.AccessToken.generate()
      authorized_conn =
        %{conn| query_string: "authorization_token=#{token}"}
        |> put_req_header("authorization", "foo")
        |> RequireAccessToken.call([])

      refute authorized_conn.halted
    end
  end
end
