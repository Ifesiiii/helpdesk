# priv/repo/migrations/20260820091422_create_organizations.exs
defmodule Helpdesk.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :plan, :string, null: false, default: "starter"
      add :settings, :map, null: false, default: %{}

      timestamps(type: :utc_datetime)
    end

    create unique_index(:organizations, [:slug])
  end
end
