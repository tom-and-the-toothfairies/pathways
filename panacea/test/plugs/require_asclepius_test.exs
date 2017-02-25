defmodule Panacea.Plugs.RequireAsclepiusTest do
  use ExUnit.Case
  use Panacea.ConnCase
  alias Panacea.Plugs.RequireAsclepius

  describe "when Asclepius is unavailable" do
    test "it returns a 503", %{conn: conn} do
      Panacea.Asclepius.set_readiness(false)

      conn = conn |> RequireAsclepius.call([])

      assert conn.status == 503
      assert conn.halted
    end
  end

  describe "when asclepius is available" do
    test "it does nothing", %{conn: conn} do
      Panacea.Asclepius.set_readiness(true)

      new_conn = conn |> RequireAsclepius.call([])

      assert new_conn == conn
      refute new_conn.halted
    end
  end
end
