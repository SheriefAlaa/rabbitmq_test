defmodule Blockchain do
  @moduledoc """
  Behavior for blockchain module that simulates a
  Blockchain using a balances table in MySQL.
  """

  @callback earn(String.t(), String.t(), Integer.t()) :: {:ok, Struct.t()} | {:error, any()}
  @callback burn(String.t(), String.t(), Integer.t()) :: {:ok, Struct.t()} | {:error, any()}
  @callback code_to_points(String.t(), String.t()) :: {:ok, Struct.t()} | {:error, any()}
  @callback points_to_rewards(String.t(), String.t()) :: {:ok, Struct.t()} | {:error, any()}

  @callback get_user_balance(String.t()) :: Integer.t()

  defp blockchain_module() do
    Application.fetch_env!(:blockchain, :blockchain_module)
  end

  @doc """
  Add some points from the user's balance.
  """
  def earn(admin_id, user_id, balance_to_add),
    do: blockchain_module().earn(admin_id, user_id, balance_to_add)

  @doc """
  Deduct some points from the user's balance.
  """
  def burn(admin_id, user_id, balance_to_deduct),
    do: blockchain_module().burn(admin_id, user_id, balance_to_deduct)

  @doc """
  args: user_id, code_id
  """
  def code_to_points(code_id, user_id), do: blockchain_module().code_to_points(code_id, user_id)

  @doc """
  Convert some points to a reward based on the user's balance can
  afford it or not
  """
  def points_to_rewards(reward_id, user_id),
    do: blockchain_module().points_to_rewards(reward_id, user_id)

  @doc """
  Get the user balance.

  Note: Each user belongs to a brand.
  """
  def get_user_balance(user_id), do: blockchain_module().get_user_balance(user_id)
end
