defmodule ApiWeb.Users.UserView do
  use ApiWeb, :view
  alias ApiWeb.Users.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      data: %{
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        language: user.language
      }
    }
  end
end
