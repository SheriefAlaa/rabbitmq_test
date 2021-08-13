defmodule ApiWeb.Admins.AdminView do
  use ApiWeb, :view

  def render("user_balance.json", %{user_id: user_id, balance: balance} = _) do
    %{user_id: user_id, balance: balance}
  end
end
