defmodule Qiibee.Repo.Migrations.CreateRewards do
  use Ecto.Migration

  def change do
    create table(:rewards, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :price_in_points, :integer
      add :brand_id, references(:brands, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:rewards, [:brand_id])
  end
end
