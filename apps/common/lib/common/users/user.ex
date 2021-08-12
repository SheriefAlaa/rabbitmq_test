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
    |> foreign_key_constraint(:brand_id, name: :users_brand_id_fkey)
    |> unique_constraint([:phone],
      name: :users_brand_id_phone_index,
      message: "Already registered with this brand"
    )
    |> unique_constraint([:email],
      name: :users_brand_id_email_index,
      message: "Already registered with this brand"
    )
  end
end
