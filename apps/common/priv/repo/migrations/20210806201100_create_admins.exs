defmodule Qiibee.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :name, :string

      timestamps()
    end

    create unique_index(:admins, [:username])
  end
end
