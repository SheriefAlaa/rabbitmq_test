defmodule ApiWeb.ErrorView do
  use ApiWeb, :view

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal Server Error"}}
  end

  def render("404.json", assigns) do
    %{errors: %{detail: Map.get(assigns, :message, "Not found")}}
  end

  def render("403.json", assigns) do
    %{errors: %{detail: Map.get(assigns, :message, "Unauthorized")}}
  end

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
