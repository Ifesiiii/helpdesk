
defmodule HelpdeskWeb.Plugs.RequestTimer do
  @moduledoc """
  Records how long a request took and exposes it as the `x-response-time` header.

  Useful in dev and staging for spotting slow endpoints without opening a profiler.
  """
  @behaviour Plug

  import Plug.Conn

  @impl true
  def init(opts) do
    # Runs at COMPILE time. Validate and normalise options here.
    Keyword.validate!(opts,
    [header: "x-response-time",
     threshold: 500
    ])
  end

  @impl true
  def call(conn, opts) do
    header = Keyword.fetch!(opts, :header)
    start = System.monotonic_time()

    register_before_send(conn, fn conn ->
      duration_us =
        System.convert_time_unit(System.monotonic_time() - start, :native, :microsecond)

      put_resp_header(conn, header, "#{duration_us}us")
    end)
  end
end
