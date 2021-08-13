defmodule ApiWeb.Admins.AdminController do
  use ApiWeb, :controller

  alias Common.Users.User
  alias Common.Users

  action_fallback(ApiWeb.FallbackController)

  @doc """
  The brand checks a user’s balance by sending the user’s UUID
  """
  def get_user_balance(conn, %{"user_id" => user_id}) do
    with %User{brand_id: user_brand_id} <- Users.get_user(user_id),
         true <- Map.get(conn.assigns[:current_brand], :id) == user_brand_id do
      render(conn, "user_balance.json", %{
        user_id: user_id,
        balance: BlockchainSqlMock.get_user_balance(user_id)
      })
    else
      false ->
        conn
        |> put_status(403)
        |> put_view(ApiWeb.ErrorView)
        |> render("403.json")

      _ ->
        conn
        |> put_status(404)
        |> put_view(ApiWeb.ErrorView)
        |> render("404.json")
    end
  end

  # The brand can credit points (Earn) or debit points (Burn)
  def earn_user_points(conn, %{
        "brand_id" => _brand_id,
        "user_id" => _user_id,
        "points" => _points
      }) do
    conn
    |> put_status(200)
    |> json("API not implemented yet.")
  end

  def burn_user_points(conn, %{
        "brand_id" => _brand_id,
        "user_id" => _user_id,
        "points" => _points
      }) do
    conn
    |> put_status(200)
    |> json("API not implemented yet.")
  end

  # The brand can see transaction history
  def list_transactions(conn, %{}) do
    conn
    |> put_status(200)
    |> json("API not implemented yet.")
  end

  # The brand can query for tx history for a particular user
  def list_transactions_for_user(conn, %{}) do
    conn
    |> put_status(200)
    |> json("API not implemented yet.")
  end
end
