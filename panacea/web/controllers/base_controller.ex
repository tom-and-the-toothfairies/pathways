defmodule Panacea.BaseController do
  use Panacea.Web, :controller
  alias Panacea.Web.Error

  def respond({:ok, response}, conn) do
    conn
    |> put_status(:ok)
    |> json(response)
  end

  def respond({:error, reason}, conn) do
    error = Error.from_reason(reason)

    conn
    |> put_status(error.status_code)
    |> json(%{error: error})
  end
end
