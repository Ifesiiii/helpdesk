defmodule Helpdesk.Tickets do
  import Ecto.Query, warn: false
  alias Helpdesk.Repo
  alias Helpdesk.Tickets.Ticket
  alias Helpdesk.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any ticket changes.

  The broadcasted messages match the pattern:

    * {:created, %Ticket{}}
    * {:updated, %Ticket{}}
    * {:deleted, %Ticket{}}
  """
  def subscribe_tickets(%Scope{} = scope) do
    key = scope.organization.id
    Phoenix.PubSub.subscribe(Helpdesk.PubSub, "organization:#{key}:tickets")
  end

  defp broadcast_ticket(%Scope{} = scope, message) do
    key = scope.organization.id
    Phoenix.PubSub.broadcast(Helpdesk.PubSub, "organization:#{key}:tickets", message)
  end

  def list_tickets(%Scope{} = scope) do
    Repo.all_by(Ticket, organization_id: scope.organization.id)
  end

  def get_ticket!(%Scope{} = scope, id) do
    Repo.get_by!(Ticket, id: id, organization_id: scope.organization.id)
  end

  def create_ticket(%Scope{} = scope, attrs) do
    with {:ok, ticket = %Ticket{}} <-
           %Ticket{}
           |> Ticket.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_ticket(scope, {:created, ticket})
      {:ok, ticket}
    end
  end

  def update_ticket(%Scope{} = scope, %Ticket{} = ticket, attrs) do
    true = ticket.organization_id == scope.organization.id

    with {:ok, ticket = %Ticket{}} <-
           ticket
           |> Ticket.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_ticket(scope, {:updated, ticket})
      {:ok, ticket}
    end
  end

  def delete_ticket(%Scope{} = scope, %Ticket{} = ticket) do
    true = ticket.organization_id == scope.organization.id

    with {:ok, ticket = %Ticket{}} <- Repo.delete(ticket) do
      broadcast_ticket(scope, {:deleted, ticket})
      {:ok, ticket}
    end
  end

  def change_ticket(%Scope{} = scope, %Ticket{} = ticket, attrs \\ %{}) do
    true = ticket.organization_id == scope.organization.id
    Ticket.changeset(ticket, attrs, scope)
  end
end
