# lib/helpdesk/tickets/ticket_tag.ex
defmodule Helpdesk.Tickets.TicketTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ticket_tags" do
    belongs_to :ticket, Helpdesk.Tickets.Ticket
    belongs_to :tag, Helpdesk.Tickets.Tag
    belongs_to :tagged_by, Helpdesk.Accounts.User

    timestamps(type: :utc_datetime, updated_at: false)
  end

  def changeset(ticket_tag, attrs) do
    ticket_tag
    |> cast(attrs, [:ticket_id, :tag_id, :tagged_by_id])
    |> validate_required([:ticket_id, :tag_id])
    |> unique_constraint([:ticket_id, :tag_id],
         message: "this ticket already has that tag")
  end
end
