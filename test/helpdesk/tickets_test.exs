defmodule Helpdesk.TicketsTest do
  use Helpdesk.DataCase

  alias Helpdesk.Tickets

  describe "tickets" do
    alias Helpdesk.Tickets.Ticket

    import Helpdesk.TicketsFixtures

    @invalid_attrs %{priority: nil, status: nil, reference: nil, body: nil, subject: nil}

    test "list_tickets/0 returns all tickets" do
      ticket = ticket_fixture()
      assert Tickets.list_tickets() == [ticket]
    end

    test "get_ticket!/1 returns the ticket with given id" do
      ticket = ticket_fixture()
      assert Tickets.get_ticket!(ticket.id) == ticket
    end

    test "create_ticket/1 with valid data creates a ticket" do
      valid_attrs = %{priority: :low, status: :open, reference: "some reference", body: "some body", subject: "some subject"}

      assert {:ok, %Ticket{} = ticket} = Tickets.create_ticket(valid_attrs)
      assert ticket.priority == :low
      assert ticket.status == :open
      assert ticket.reference == "some reference"
      assert ticket.body == "some body"
      assert ticket.subject == "some subject"
    end

    test "create_ticket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tickets.create_ticket(@invalid_attrs)
    end

    test "update_ticket/2 with valid data updates the ticket" do
      ticket = ticket_fixture()
      update_attrs = %{priority: :normal, status: :pending, reference: "some updated reference", body: "some updated body", subject: "some updated subject"}

      assert {:ok, %Ticket{} = ticket} = Tickets.update_ticket(ticket, update_attrs)
      assert ticket.priority == :normal
      assert ticket.status == :pending
      assert ticket.reference == "some updated reference"
      assert ticket.body == "some updated body"
      assert ticket.subject == "some updated subject"
    end

    test "update_ticket/2 with invalid data returns error changeset" do
      ticket = ticket_fixture()
      assert {:error, %Ecto.Changeset{}} = Tickets.update_ticket(ticket, @invalid_attrs)
      assert ticket == Tickets.get_ticket!(ticket.id)
    end

    test "delete_ticket/1 deletes the ticket" do
      ticket = ticket_fixture()
      assert {:ok, %Ticket{}} = Tickets.delete_ticket(ticket)
      assert_raise Ecto.NoResultsError, fn -> Tickets.get_ticket!(ticket.id) end
    end

    test "change_ticket/1 returns a ticket changeset" do
      ticket = ticket_fixture()
      assert %Ecto.Changeset{} = Tickets.change_ticket(ticket)
    end
  end
end
