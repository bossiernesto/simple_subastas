defmodule SimpleSubasta.Router do
  use SimpleSubasta.Web, :router

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

  scope "/", SimpleSubasta do
    pipe_through :browser # Use the default browser stack

    get "/", SubastaController, :clientrender
  end

  scope "/api", SimpleSubasta do
    pipe_through :api

    resources "/subastas", SubastaController, except: [:new, :edit] do
      post "/cancelar", SubastaController, :cancelar
      resources "/ofertas", OfertaController, except: [:new, :edit]
    end
  end
end
