defmodule HelpdeskWeb.TicketController do
  use HelpdeskWeb, :controller

def show(conn, _params) do
  history = [
    %{
      action: "Ticket created",
      actor: "Ada",
      time: "09:15"
    },
    %{
      action: "Assigned to Support Team",
      actor: "System",
      time: "09:20"
    },
    %{
      action: "Status changed to In Progress",
      actor: "Grace",
      time: "09:45"
    },
    %{
      action: "Ticket resolved",
      actor: "Grace",
      time: "11:30"
    }
  ]

  render(conn, :show,
    ticket: conn.assigns.ticket,
    history: history
  )
end


end
#   alias Helpdesk.Tickets

#   plug :load_ticket when action in [:show, :edit, :update, :delete]
#   plug :authorize_ticket when action in [:edit, :update, :delete]

#   def show(conn, _params) do
#     render(conn, :show, ticket: conn.assigns.ticket)
#   end

#   def edit(conn, _params) do
#     changeset = Tickets.change_ticket(conn.assigns.ticket)
#     render(conn, :edit, changeset: changeset)
#   end

#   defp load_ticket(conn, _opts) do
#     assign(conn, :ticket, Tickets.get_ticket!(conn.params["id"]))
#   end

#   defp authorize_ticket(conn, _opts) do
#     if conn.assigns.ticket.organization_id == conn.assigns.current_scope.organization.id do
#       conn
#     else
#       conn
#       |> put_status(:forbidden)
#       |> put_view(html: HelpdeskWeb.ErrorHTML)
#       |> render(:"403")
#       |> halt()
#     end
#   end
# end
