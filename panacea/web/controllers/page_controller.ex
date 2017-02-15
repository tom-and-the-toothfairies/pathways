defmodule Panacea.PageController do
  use Panacea.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
