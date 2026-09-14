# priv/repo/migrations/..._create_comments.exs
defmodule Helpdesk.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text, null: false
      add :internal, :boolean, null: false, default: false

      add :ticket_id, references(:tickets, on_delete: :delete_all), null: false
      add :author_id, references(:users, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:ticket_id])
    create index(:comments, [:author_id])
  end
end
