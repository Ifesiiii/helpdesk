defmodule Helpdesk.Tickets.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tickets" do
    field :reference, :string
    field :subject, :string
    field :body, :string
    field :status, Ecto.Enum, values: [:open, :pending, :on_hold, :resolved, :closed]
    field :priority, Ecto.Enum, values: [:low, :normal, :high, :urgent]
    field :organization_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:reference, :subject, :body, :status, :priority])
    |> validate_required([:reference, :subject, :body, :status, :priority])
  end
end
