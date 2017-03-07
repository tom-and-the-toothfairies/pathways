defmodule Panacea.AuthorizedConnCase do
  @moduledoc """
  The `:api` pipeline requires an authorization header to be
  present. This module defines the test case to be used by
  tests that require setting up an authorized connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      import Panacea.Router.Helpers

      # The default endpoint for testing
      @endpoint Panacea.Endpoint
    end
  end

  setup _tags do
    token = Panacea.AccessToken.generate
    conn =
      Phoenix.ConnTest.build_conn()
      |> Plug.Conn.put_req_header("authorization", token)

    {:ok, conn: conn}
  end
end
