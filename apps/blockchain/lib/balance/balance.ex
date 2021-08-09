defmodule Blockchain.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  alias Common.{
    Admins.Admin,
    Rewards.Reward,
    Users.User,
    Codes.Code
  }

  @allowed [:admin_id, :reward_id, :code_id, :user_id, :balance]
  @required [:user_id, :balance]
  @assocs [:admin_id, :reward_id, :code_id]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "balances" do
    belongs_to(:admin, Admin)
    belongs_to(:code, Code)
    belongs_to(:reward, Reward)
    belongs_to(:user, User)
    field(:balance, :integer)

    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, @allowed)
    |> validate_required(@required)
    |> require_one_assoc_only(attrs)
    |> foreign_key_constraint(:admin_id, name: :balances_admin_id_fkey)
    |> foreign_key_constraint(:code_id, name: :balances_code_id_fkey)
    |> foreign_key_constraint(:reward_id, name: :balances_reward_id_fkey)
    |> unique_constraint([:code_id, :user_id], name: :balances_code_id_user_id_fkey)
  end

  @doc """
  Require at least one assoc id + user_id is required.

  If admin_id is present, then the row will be regarded as earn/burn operation.
  If code_id is present, then the row will be regarded as code_to_points operation.
  If reward_id is present, then the row will be regarded as points_to_reward operation.
  """
  def require_one_assoc_only(changeset, attrs) do
    keys = filter_none_assoc_keys(attrs)

    cond do
      length(keys) > 1 ->
        Enum.reduce(keys, changeset, fn key, acc ->
          add_error(acc, key, "only one assoc key can be passed.")
        end)

      length(keys) == 1 ->
        key = hd(keys)
        put_change(changeset, key, attrs[key])

      true ->
        add_error(
          changeset,
          :id,
          "Cannot proceed without at least one assoc: #{Enum.join(@assocs, ", ")}"
        )
    end
  end

  defp filter_none_assoc_keys(attrs) do
    attrs
    |> Map.keys()
    |> Enum.filter(fn k -> k in @assocs end)
  end
end
