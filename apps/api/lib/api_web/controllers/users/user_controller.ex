defmodule ApiWeb.Users.UserController do
  use ApiWeb, :controller

  alias Common.Users

  action_fallback(ApiWeb.FallbackController)

  def register(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(201)
        |> render("user.json", user: user)

      error ->
        error
    end
  end
end
