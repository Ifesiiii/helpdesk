
defmodule HelpdeskWeb.Plugs.RequireApiKey do
  @behaviour Plug

  import Plug.Conn

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         true <- valid_token?(token) do
      assign(conn, :api_authenticated?, true)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{error: "invalid or missing API key"})
        |> halt()
    end
  end

  defp valid_token?(token) do
    expected = Application.get_env(:helpdesk, :api_key)
    is_binary(expected) and Plug.Crypto.secure_compare(token, expected)
  end
end
