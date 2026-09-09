defmodule Helpdesk.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :reference, :string
      add :subject, :string
      add :body, :text
      add :status, :string
      add :priority, :string
      add :organization_id, references(:organizations, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:tickets, [:organization_id])
  end
end
