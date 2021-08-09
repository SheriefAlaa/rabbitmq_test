defmodule Qiibee.Repo.Migrations.CreateBalances do
  use Ecto.Migration

  def change do
    create table(:balances, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :code_id, references(:codes, on_delete: :nothing, type: :binary_id), null: true
      add :admin_id, references(:admins, on_delete: :nothing, type: :binary_id), null: true
      add :reward_id, references(:rewards, on_delete: :nothing, type: :binary_id), null: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      # Can be -ve or +ve.
      add :balance, :bigint, null: false

      timestamps()
    end

    create index(:balances, [:user_id])

    # A code can only be used once (according to the assignment's spec).
    create unique_index(:balances, [:code_id, :user_id])

    # Unfortunately not supported in the mysql adapter yet but supported in mysql 8.0.16+.
    # To save time, we will implement the following check inside the changeset.
    # create(
    #   constraint(:balances, :admin_id_or_brand_id_or_code_id_required,
    #     check: "(admin_id IS NOT NULL) OR (brand_id IS NOT NULL) OR (code_id IS NOT NULL)"
    #   )
    # )
  end
end
