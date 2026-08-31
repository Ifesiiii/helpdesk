defmodule HelpdeskWeb.Router do
  use HelpdeskWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HelpdeskWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_authenticated do
    plug :accepts, ["json"]
    plug HelpdeskWeb.Plugs.RequireApiKey
  end

  pipeline :admin do
    plug :require_admin_role
  end

  pipeline :require_authenticated_user do
    plug :chapter4_auth_placeholder
  end

  scope "/", HelpdeskWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/about", PageController, :about
    get "/pricing", PageController, :pricing
  end

  # ---------- Authenticated agent area ----------
  scope "/", HelpdeskWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/tickets", TicketController do
      resources "/comments", CommentController, only: [:create, :delete]
    end

  get "/tickets/new", TicketController, :new
  get "/tickets/:id", TicketController, :show


    get "/inbox", InboxController, :index
    get "/settings", SettingsController, :edit
    put "/settings", SettingsController, :update
  end

  # ---------- Org administration ----------
  scope "/admin", HelpdeskWeb.Admin, as: :admin do
    pipe_through [:browser, :require_authenticated_user, :admin]

    resources "/members", MemberController
    resources "/teams", TeamController
    get "/audit", AuditController, :index
  end

  # ---------- JSON API, versioned ----------
  scope "/api/v1", HelpdeskWeb.Api.V1, as: :api_v1 do
    pipe_through :api_authenticated

    resources "/tickets", TicketController, except: [:new, :edit]
    resources "/organizations", OrganizationController, only: [:show]
    get "/me", SessionController, :me
    get "/health", HealthController, :show
  end

  # ---------- Dev only ----------
  if Application.compile_env(:helpdesk, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HelpdeskWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp chapter4_auth_placeholder(conn, _opts), do: conn

  defp require_admin_role(
         %{assigns: %{current_scope: %{user: %{role: :admin}}}} = conn,
         _opts
       ) do
    conn
  end

  defp require_admin_role(conn, _opts) do
    conn
    |> put_flash(:error, "You don't have access to that page.")
    |> redirect(to: "/")
    |> halt()
  end
end
