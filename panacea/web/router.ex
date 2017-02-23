defmodule Panacea.Router do
  use Panacea.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :requires_asclepius do
    plug Panacea.Plugs.RequireAsclepius, []
  end

  scope "/", Panacea do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Panacea do
    # use browser pipeline until we add some simple
    # auth to api pipeline
    pipe_through :browser

    post "/pml", PmlController, :upload

    scope "/asclepius", Panacea do
      pipe_through :requires_asclepius
    end
  end
end
