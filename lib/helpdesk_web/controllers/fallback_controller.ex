defmodule HelpdeskWeb.FallbackController do
  use HelpdeskWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: HelpdeskWeb.ErrorHTML, json: HelpdeskWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(:forbidden)
    |> put_view(html: HelpdeskWeb.ErrorHTML, json: HelpdeskWeb.ErrorJSON)
    |> render(:"403")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: HelpdeskWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, reason}) when is_atom(reason) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(html: HelpdeskWeb.ErrorHTML, json: HelpdeskWeb.ErrorJSON)
    |> render(:"500")
  end
end
