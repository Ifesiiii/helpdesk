# lib/helpdesk/accounts/user.ex
defmodule Helpdesk.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :role, Ecto.Enum, values: [:owner, :admin, :agent], default: :agent
    field :avatar_url, :string
    field :confirmed_at, :utc_datetime

    belongs_to :organization, Helpdesk.Accounts.Organization

    has_many :requested_tickets, Helpdesk.Tickets.Ticket, foreign_key: :requester_id
    has_many :assigned_tickets, Helpdesk.Tickets.Ticket, foreign_key: :assignee_id

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :avatar_url])
    |> validate_required([:name, :email])
    |> validate_length(:name, min: 1, max: 100)
    |> validate_email()
    |> unique_constraint(:email)
  end

@doc """
Changeset for changing a user's role. Separate from `changeset/2` so that
`:role` can never be set from a profile form.
"""
  def role_changeset(user, attrs) do
    user
    |> cast(attrs, [:role])
    |> validate_required([:role])
    |> validate_inclusion(:role, [:owner, :admin, :agent])
  end

  defp validate_email(changeset) do
    changeset
    |> update_change(:email, &(&1 |> String.trim() |> String.downcase()))
    |> validate_format(:email, ~r/^[^@,;\s]+@[^@,;\s]+\.[^@,;\s]+$/,
       message: "must be a valid email address")
    |> validate_length(:email, max: 160)
  end
end
