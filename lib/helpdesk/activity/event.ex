defmodule Helpdesk.Activity.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activity_events" do
    field :type, :string
    field :subject_type, :string
    field :subject_id, :integer
    field :metadata, :map, default: %{}

    belongs_to :organization, Helpdesk.Accounts.Organization
    belongs_to :actor, Helpdesk.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :type,
      :subject_type,
      :subject_id,
      :metadata,
      :organization_id,
      :actor_id
    ])
    |> validate_required([
      :type,
      :subject_type,
      :subject_id,
      :organization_id
    ])
  end
end
