defmodule Common.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Common.Brands.Brand

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :language, :string
    belongs_to(:brand, Brand)

    # Virtuals
    field :balance, :decimal, default: Decimal.new(0), virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    allowed = [
      :name,
      :email,
      :phone,
      :language,
      :brand_id
    ]

    user
    |> cast(attrs, allowed)
    |> validate_required(allowed)
  end
end
