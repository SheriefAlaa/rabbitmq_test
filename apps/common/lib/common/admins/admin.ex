defmodule Common.Admins.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "admins" do
    field :name, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:username, :name])
    |> validate_required([:username, :name])
    |> unique_constraint(:username, name: :admins_username_index, message: "taken")
  end
end
