# lib/helpdesk/tickets/ticket.ex
defmodule Helpdesk.Tickets.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :reference}

  schema "tickets" do
    field :reference, :string
    field :subject, :string
    field :body, :string
    field :status, Ecto.Enum,
      values: [:open, :pending, :on_hold, :resolved, :closed],
      default: :open

    field :priority, Ecto.Enum,
      values: [:low, :normal, :high, :urgent],
      default: :normal

    field :resolved_at, :utc_datetime
    field :due_at, :utc_datetime

    # not a column — computed at query time in Chapter 13
    field :comment_count, :integer, virtual: true

    belongs_to :organization, Helpdesk.Accounts.Organization
    belongs_to :requester, Helpdesk.Accounts.User
    belongs_to :assignee, Helpdesk.Accounts.User

    timestamps(type: :utc_datetime)
  end
  def create_changeset(ticket, attrs) do
  ticket
  |> cast(attrs, [:subject, :body, :priority, :due_at])
  |> validate_required([:subject, :body])
  |> validate_length(:subject, min: 3, max: 200)
  |> validate_length(:body, min: 1, max: 20_000)
  |> validate_due_in_future()
end

@doc """
Changeset for agent updates: status, assignment, priority.
"""
def update_changeset(ticket, attrs) do
  ticket
  |> cast(attrs, [:subject, :body, :status, :priority, :assignee_id, :due_at])
  |> validate_required([:subject, :body, :status, :priority])
  |> validate_length(:subject, min: 3, max: 200)
  |> validate_status_transition()
  |> sync_resolved_at()
  |> foreign_key_constraint(:assignee_id)
end

@valid_transitions %{
  open: [:pending, :on_hold, :resolved, :closed],
  pending: [:open, :on_hold, :resolved, :closed],
  on_hold: [:open, :pending, :resolved, :closed],
  resolved: [:open, :closed],
  closed: [:open]
}

defp validate_status_transition(changeset) do
  case {changeset.data.status, get_change(changeset, :status)} do
    {_, nil} ->
      changeset

    {from, to} when is_nil(from) ->
      # new record, any initial status is fine
      _ = to
      changeset

    {from, to} ->
      if to in Map.get(@valid_transitions, from, []) do
        changeset
      else
        add_error(changeset, :status, "cannot move from %{from} to %{to}",
          from: from, to: to, validation: :status_transition)
      end
  end
end

defp sync_resolved_at(changeset) do
  case get_change(changeset, :status) do
    :resolved -> put_change(changeset, :resolved_at, DateTime.utc_now(:second))
    nil -> changeset
    _other -> put_change(changeset, :resolved_at, nil)
  end
end

defp validate_due_in_future(changeset) do
  validate_change(changeset, :due_at, fn :due_at, due_at ->
    if DateTime.compare(due_at, DateTime.utc_now()) == :gt,
      do: [],
      else: [due_at: "must be in the future"]
  end)
end
end
