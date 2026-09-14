# lib/helpdesk/tickets/comment.ex
defmodule Helpdesk.Tickets.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :internal, :boolean, default: false

    belongs_to :ticket, Helpdesk.Tickets.Ticket
    belongs_to :author, Helpdesk.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :internal])
    |> validate_required([:body])
    |> validate_length(:body, min: 1, max: 20_000)
    |> foreign_key_constraint(:ticket_id)
    |> foreign_key_constraint(:author_id)
  end
end
