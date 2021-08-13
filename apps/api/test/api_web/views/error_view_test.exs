defmodule ApiWeb.ErrorViewTest do
  use ApiWeb.ConnCase, async: true

  alias Common.Admins.Admin

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(ApiWeb.ErrorView, "404.json", []) == %{errors: %{detail: "Not found"}}
  end

  test "renders 500.json" do
    assert render(ApiWeb.ErrorView, "500.json", []) ==
             %{errors: %{detail: "Internal Server Error"}}
  end

  test "renders errors.json" do
    assert %{errors: %{name: ["can't be blank"], username: ["can't be blank"]}} =
             render(ApiWeb.ChangesetView, "error.json", %{
               changeset: Admin.changeset(%Admin{}, %{})
             })
  end
end
