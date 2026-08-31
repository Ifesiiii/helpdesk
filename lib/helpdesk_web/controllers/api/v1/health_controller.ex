# lib/helpdesk_web/controllers/api/v1/health_controller.ex
defmodule HelpdeskWeb.Api.V1.HealthController do
  use HelpdeskWeb, :controller

  def show(conn, _params) do
    json(conn, %{
      status: "ok",
      version: Application.spec(:helpdesk, :vsn) |> to_string(),
      time: DateTime.utc_now()
    })
  end
end
