defmodule Qiibee.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brands, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :admin_id, references(:admins, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:brands, [:admin_id])
  end
end
