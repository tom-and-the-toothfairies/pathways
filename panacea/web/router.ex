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
    plug Panacea.Plugs.RequireAccessToken, []
  end

  scope "/", Panacea do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Panacea do
    pipe_through :api

    post "/pml", PmlController, :upload
    post "/uris", AsclepiusController, :uris_for_labels
    post "/ddis", AsclepiusController, :ddis
    get  "/ast", AstController, :to_pml
  end
end
