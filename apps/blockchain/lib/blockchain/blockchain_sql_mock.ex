defmodule BlockchainSqlMock do
  @moduledoc """
  Implements Blockchain.Behaviour through the balances MySQL table.
  """
  import Ecto.Query, warn: false

  @behaviour Blockchain

  alias Qiibee.Repo
  alias Blockchain.Balance
  alias Common.Rewards.Reward
  alias Common.Codes.Code
  alias Common.Users.User
  alias Common.Users
  alias Common.{Codes, Rewards}

  @impl true
  def earn(admin_id, user_id, balance_to_add) do
    %Balance{}
    |> Balance.changeset(%{
      admin_id: admin_id,
      user_id: user_id,
      balance: balance_to_add
    })
    |> Repo.insert()
  end

  @impl true
  def burn(admin_id, user_id, balance_to_deduct) do
    %Balance{}
    |> Balance.changeset(%{
      admin_id: admin_id,
      user_id: user_id,
      balance: abs(balance_to_deduct) * -1
    })
    |> Repo.insert()
  end

  @impl true
  def code_to_points(code_id, user_id) do
    with %User{brand_id: brand_id} = Users.get_user(user_id),
         %Code{expires_at: expires_at, brand_id: code_brand_id} = code <- Codes.get_code(code_id),
         true <- brand_id == code_brand_id,
         :gt <- NaiveDateTime.compare(expires_at, NaiveDateTime.utc_now()) do
      %Balance{}
      |> Balance.changeset(%{
        code_id: code_id,
        user_id: user_id,
        balance: code.points
      })
      |> Repo.insert()
    else
      nil ->
        {:error, :code_not_found}

      false ->
        {:error, :user_not_associated_with_brand}

      _ ->
        {:error, :code_expired}
    end
  end

  @impl true
  def points_to_rewards(reward_id, user_id) do
    with %Reward{} = reward <- Rewards.get_reward(reward_id),
         balance = get_user_balance(user_id),
         true <- is_integer(balance),
         true <- reward.price_in_points <= balance do
      %Balance{}
      |> Balance.changeset(%{
        reward_id: reward.id,
        user_id: user_id,
        balance: reward.price_in_points * -1
      })
      |> Repo.insert()
    else
      false ->
        {:error, :insufficient_funds}

      nil ->
        {:error, :reward_not_found}

      error ->
        error
    end
  end

  @doc """
  Get user's balance of points.
  """
  @impl true
  def get_user_balance(user_id) do
    from(b in Balance, where: b.user_id == ^user_id, select: sum(b.balance))
    |> Repo.one()
    |> Decimal.to_integer()
  end
end
