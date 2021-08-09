defmodule Common.Brands.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  alias Common.Admins.Admin

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "brands" do
    field :name, :string
    belongs_to(:admin, Admin)

    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
