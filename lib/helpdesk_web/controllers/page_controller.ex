defmodule HelpdeskWeb.PageController do
  use HelpdeskWeb, :controller

  plug :put_page_section

  def home(conn, _params) do
    render(conn, :home)
  end

  def about(conn, _params) do
    render(conn, :about)
  end

  defp put_page_section(conn, _opts) do
    assign(conn, :page_section, "marketing")
  end
end
