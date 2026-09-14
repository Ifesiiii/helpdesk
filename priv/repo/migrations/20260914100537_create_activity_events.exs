defmodule Helpdesk.Repo.Migrations.CreateActivityEvents do
  use Ecto.Migration

  def change do
  create table(:activity_events) do
    add :type, :string, null: false
    add :subject_type, :string, null: false
    add :subject_id, :bigint, null: false
    add :metadata, :map, null: false, default: %{}

    add :organization_id,
        references(:organizations, on_delete: :delete_all),
        null: false

    add :actor_id,
        references(:users, on_delete: :nilify_all)

    timestamps(type: :utc_datetime)
  end

  create index(:activity_events, [:organization_id])
end
end
