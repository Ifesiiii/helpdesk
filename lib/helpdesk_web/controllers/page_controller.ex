defmodule HelpdeskWeb.PageController do
  use HelpdeskWeb, :controller

  plug :put_page_section
  plug :put_marketing_nav

  def home(conn, _params) do
    render(conn, :home, page_title: "Helpdesk")
  end

  defp put_page_section(conn, _opts) do
    assign(conn, :page_section, "marketing")
  end

  def about(conn, _params) do
    render(conn, :about,
      page_title: "About",
      team_size: 24,
      founded: 2019
    )
  end

  def pricing(conn, _params) do
    render(conn, :pricing, page_title: "Pricing", plans: plans())
  end

  defp put_marketing_nav(conn, _opts) do
    assign(conn, :nav_items, [
      %{label: "Home", path: ~p"/"},
      %{label: "About", path: ~p"/about"},
      %{label: "Pricing", path: ~p"/pricing"}
    ])
  end

  defp plans do
    [
      %{name: "Starter", price: 0, seats: 3, features: ["Email support", "1 inbox"]},
      %{
        name: "Team",
        price: 49,
        seats: 15,
        features: ["Everything in Starter", "SLAs", "API access"]
      },
      %{
        name: "Business",
        price: 149,
        seats: :unlimited,
        features: ["Everything in Team", "SSO", "Audit log"]
      }
    ]
  end
end
