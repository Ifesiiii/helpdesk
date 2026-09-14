defmodule Helpdesk.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Helpdesk.Repo
  alias Helpdesk.Accounts.{Organization, User, Scope}

  def get_organization!(id) do
    Repo.get!(Organization, id)
  end

  def list_users(%Scope{} = scope) do
    User
    |> where([u], u.organization_id == ^scope.organization.id)
    |> Repo.all()
  end

  def get_user!(%Scope{} = scope, id) do
    Repo.get_by!(
      User,
      id: id,
      organization_id: scope.organization.id
    )
  end

  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  def change_organization(%Organization{} = organization, attrs \\ %{}) do
    Organization.changeset(organization, attrs)
  end
end
