defmodule Helpdesk.TicketsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Helpdesk.Tickets` context.
  """

  @doc """
  Generate a ticket.
  """
  def ticket_fixture(attrs \\ %{}) do
    {:ok, ticket} =
      attrs
      |> Enum.into(%{
        body: "some body",
        priority: :low,
        reference: "some reference",
        status: :open,
        subject: "some subject"
      })
      |> Helpdesk.Tickets.create_ticket()

    ticket
  end
end
