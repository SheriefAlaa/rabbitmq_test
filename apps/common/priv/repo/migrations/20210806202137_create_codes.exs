defmodule Qiibee.Repo.Migrations.CreateCodes do
  use Ecto.Migration

  def change do
    create table(:codes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :expires_at, :naive_datetime
      add :code, :string
      add :points, :integer
      add :brand_id, references(:brands, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:codes, [:brand_id])

    create unique_index(:codes, [:code, :brand_id])
  end
end
