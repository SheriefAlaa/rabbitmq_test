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

    scope "/user", Users, as: :users do
      pipe_through ApiWeb.Plugs.AuthUser

      post "/code_to_points", UserController, :code_to_points
    end

    scope "/admin", Admins, as: :admins do
      pipe_through ApiWeb.Plugs.AuthAdmin

      get "/user_balance/:user_id", AdminController, :get_user_balance
    end
  end
end
