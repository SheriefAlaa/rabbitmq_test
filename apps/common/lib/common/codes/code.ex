defmodule Common.Codes.Code do
  use Ecto.Schema
  import Ecto.Changeset
  alias Common.Brands.Brand

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "codes" do
    field :code, :string
    field :expires_at, :naive_datetime
    field :points, :integer
    belongs_to(:brand, Brand)

    timestamps()
  end

  @doc false
  def changeset(code, attrs) do
    code
    |> cast(attrs, [:brand_id, :expires_at, :code, :points])
    |> validate_required([:brand_id, :expires_at, :code, :points])
  end
end
