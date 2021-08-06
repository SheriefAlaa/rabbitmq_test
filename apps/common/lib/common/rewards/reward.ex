defmodule Common.Rewards.Reward do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rewards" do
    field :name, :string
    field :price_in_points, :integer
    field :brand_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(reward, attrs) do
    reward
    |> cast(attrs, [:name, :price_in_points])
    |> validate_required([:name, :price_in_points])
  end
end
