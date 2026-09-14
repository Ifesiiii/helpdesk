# priv/repo/migrations/..._create_tags.exs
defmodule Helpdesk.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string, null: false
      add :color, :string, null: false, default: "neutral"
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tags, [:organization_id, :name])

    create table(:ticket_tags) do
      add :ticket_id, references(:tickets, on_delete: :delete_all), null: false
      add :tag_id, references(:tags, on_delete: :delete_all), null: false
      add :tagged_by_id, references(:users, on_delete: :nilify_all)

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create unique_index(:ticket_tags, [:ticket_id, :tag_id])
    create index(:ticket_tags, [:tag_id])
  end
end
