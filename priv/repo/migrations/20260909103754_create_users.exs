# priv/repo/migrations/..._create_users.exs
defmodule Helpdesk.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :name, :string, null: false
      add :role, :string, null: false, default: "agent"
      add :avatar_url, :string
      add :confirmed_at, :utc_datetime

      add :organization_id,
          references(:organizations, on_delete: :delete_all),
          null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
    create index(:users, [:organization_id])
  end
end
