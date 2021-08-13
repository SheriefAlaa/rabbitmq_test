defmodule ApiWeb.Users.UserController do
  use ApiWeb, :controller

  alias Common.{Users, Codes}
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

  def code_to_points(conn, %{"code" => code}) do
    case Codes.get_code_by(code) do
      nil ->
        conn
        |> put_status(404)
        |> put_view(ApiWeb.ErrorView)
        |> render("404.json", %{message: "Not found or expired!"})

      code ->
        # Might also want to check the balances table before
        # publishing just to not give better feedback to the
        # user instead of just sending 200 ok.
        Config.user_producer_module().publish_code_to_points(%{
          code_id: code.id,
          user_id: conn.assigns[:current_user].id
        })

        conn
        |> put_status(200)
        |> json("ok")
    end
  end
end
