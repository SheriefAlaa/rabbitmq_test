defmodule ApiWeb.Users.UserController do
  use ApiWeb, :controller

  alias Common.Users
  alias PublisherConsumer.Config

  action_fallback(ApiWeb.FallbackController)

  def register(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        Config.email_producer_module().publish_email(%{
          email: user.email,
          message: "#{user.name}, thank you for registering with us. Your phone is #{user.phone}!"
        })

        conn
        |> put_status(201)
        |> render("user.json", user: user)

      error ->
        error
    end
  end
end
