defmodule Qiibee.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :string
      add :phone, :string
      add :language, :string
      add :brand_id, references(:brands, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
  end
end
