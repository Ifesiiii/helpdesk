defmodule HelpdeskWeb.Plugs.RequestTimer do
  @behaviour Plug

  import Plug.Conn
  require Logger

  @impl true
  def init(opts) do
    opts =
      Keyword.validate!(opts,
        header: "x-response-time",
        threshold: 500
      )

    threshold = Keyword.fetch!(opts, :threshold)

    unless is_integer(threshold) and threshold > 0 do
      raise ArgumentError,
            ":threshold must be a positive integer representing milliseconds"
    end

    opts
  end

  @impl true
  def call(conn, opts) do
    header = Keyword.fetch!(opts, :header)
    threshold_ms = Keyword.fetch!(opts, :threshold)

    start = System.monotonic_time()

    register_before_send(conn, fn conn ->
      duration_us =
        System.convert_time_unit(
          System.monotonic_time() - start,
          :native,
          :microsecond
        )

      if duration_us > threshold_ms * 1_000 do
        Logger.warning(
          "Slow request #{conn.method} #{conn.request_path} took #{duration_us / 1_000}ms " <>
            "(threshold: #{threshold_ms}ms)"
        )
      end

      put_resp_header(conn, header, "#{duration_us}us")
    end)
  end
end
