# lib/helpdesk/accounts/organization.ex
defmodule Helpdesk.Accounts.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :slug}

  schema "organizations" do
    field :name, :string
    field :slug, :string
    field :plan, Ecto.Enum, values: [:starter, :team, :business], default: :starter
    # field :map, default: %{}
    embeds_one :settings, Helpdesk.Accounts.Organization.Settings,
    on_replace: :update

    has_many :users, Helpdesk.Accounts.User
    has_many :tickets, Helpdesk.Tickets.Ticket

    timestamps(type: :utc_datetime)
  end

def settings_changeset(organization, attrs) do
  organization
  |> cast(attrs, [])
  |> cast_embed(:settings)
end

def changeset(organization, attrs) do
  organization
  |> cast(attrs, [:name, :slug, :plan])
  |> validate_required([:name, :slug])
  |> validate_length(:name, min: 2, max: 100)
  |> validate_format(:slug, ~r/^[a-z0-9-]+$/,
       message: "may only contain lowercase letters, numbers and hyphens")
  |> validate_length(:slug, min: 2, max: 40)
  |> unique_constraint(:slug)|> cast(attrs, [:name, :slug, :plan, :settings])
  |> validate_required([:name, :slug])
  |> validate_length(:name, min: 2, max: 100)
  |> update_change(:slug, &String.downcase/1)
  |> validate_format(:slug, ~r/^[a-z0-9][a-z0-9-]*[a-z0-9]$/,
       message: "must start and end with a letter or number, and may contain hyphens")
  |> validate_length(:slug, min: 2, max: 40)
  |> validate_exclusion(:slug, ~w(admin api app www help support dev static assets),
       message: "is reserved")
  |> unsafe_validate_unique(:slug, Helpdesk.Repo)
  |> unique_constraint(:slug)

end
end
