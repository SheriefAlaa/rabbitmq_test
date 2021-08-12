defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiWeb do
    pipe_through :api

    scope "/user", Users, as: :users do
      post "/register", UserController, :register
    end
  end
end
