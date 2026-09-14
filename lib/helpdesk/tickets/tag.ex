defmodule Helpdesk.Tickets.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string

    belongs_to :organization, Helpdesk.Accounts.Organization

    many_to_many :tickets, Helpdesk.Tickets.Ticket,
      join_through: Helpdesk.Tickets.TicketTag

    timestamps(type: :utc_datetime)
  end

  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
