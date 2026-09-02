defmodule HelpdeskWeb.PlaygroundController do
  use HelpdeskWeb, :controller

  action_fallback HelpdeskWeb.FallbackController


  def show(conn, _params) do
    render(conn, :show, page_title: "show")
  end


  def not_found(_conn, _params) do
    {:error, :not_found}
  end

  def forbidden(_conn, _params) do
    {:error, :forbidden}
  end

  def render_example(conn, _params) do
    render(conn, :show, message: "Rendered from a template")
  end

  def redirect_example(conn, _params) do
    redirect(conn, to: "/about")
  end

  def json_example(conn, _params) do
    json(conn, %{status: "ok", count: 42})
  end

  def safe_redirect(conn, %{"next" => next}) do
    allowed_paths = [
      "/",
      "/about",
      "/pricing"
    ]

    destination =
      if next in allowed_paths do
        next
      else
        "/"
      end

    redirect(conn, to: destination)
  end

  def safe_redirect(conn, _params) do
    redirect(conn, to: "/")
  end

  def text_example(conn, _params) do
    text(conn, "pong")
  end

  def html_example(conn, _params) do
    html(conn, "<h1>Hello from Playground</h1>")
  end

  def no_content(conn, _params) do
    send_resp(conn, 204, "")
  end

  def download(conn, _params) do
    csv_data = """
    name,email
    Ada,ada@example.com
    Grace,grace@example.com
    """

    send_download(
      conn,
      {:binary, csv_data},
      filename: "playground.csv"
    )
  end
end
