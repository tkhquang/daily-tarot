import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :daily_tarot, DailyTarotWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  # Needed for Phoenix 1.2 and 1.4. Doesn't hurt for 1.3.
  http: [port: {:system, "PORT"}],
  url: [
    scheme: System.get_env("URL_SCHEME"),
    host: System.get_env("URL_HOST"),
    port: System.get_env("URL_PORT")
  ],
  check_origin: System.get_env("CHECK_ORIGIN") |> String.split(","),
  force_ssl: [rewrite_on: [:x_forwarded_proto], host: nil]

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: DailyTarot.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
