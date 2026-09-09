# priv/repo/migrations/..._create_tickets.exs
defmodule Helpdesk.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :reference, :string, null: false
      add :subject, :string, null: false
      add :body, :text, null: false
      add :status, :string, null: false, default: "open"
      add :priority, :string, null: false, default: "normal"
      add :resolved_at, :utc_datetime
      add :due_at, :utc_datetime

      add :organization_id, references(:organizations, on_delete: :delete_all), null: false
      add :requester_id, references(:users, on_delete: :restrict), null: false
      add :assignee_id, references(:users, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tickets, [:organization_id, :reference])
    create index(:tickets, [:organization_id, :status])
    create index(:tickets, [:assignee_id], where: "assignee_id IS NOT NULL")
    create index(:tickets, [:requester_id])
  end
end
