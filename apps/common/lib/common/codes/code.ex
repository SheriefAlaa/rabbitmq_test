defmodule Common.Codes.Code do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "codes" do
    field :code, :string
    field :expires_at, :naive_datetime
    field :points, :integer
    field :brand_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(code, attrs) do
    code
    |> cast(attrs, [:expires_at, :code, :points])
    |> validate_required([:expires_at, :code, :points])
  end
end
