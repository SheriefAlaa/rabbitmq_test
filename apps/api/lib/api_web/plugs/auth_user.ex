defmodule ApiWeb.Plugs.AuthUser do
  @behaviour Plug

  import Plug.Conn

  alias Common.Users.User
  alias Common.Users

  def init(opts), do: opts

  def call(conn, _opts) do
    with [bearer_token] <- get_req_header(conn, "authorization"),
         user_id = String.replace(bearer_token, "Bearer ", ""),
         %User{} = user <- Users.get_user(user_id) do
      assign(conn, :current_user, user)
    else
      error ->
        IO.inspect(error, label: :user_auth_error)

        conn
        |> put_status(403)
        |> Phoenix.Controller.put_view(ApiWeb.ErrorView)
        |> Phoenix.Controller.render("403.json")
        |> halt()
    end
  end
end
