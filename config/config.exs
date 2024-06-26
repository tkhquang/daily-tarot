# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :daily_tarot, DailyTarot, imgix_url: System.get_env("IMGIX_URL")

config :daily_tarot,
  ecto_repos: [DailyTarot.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :daily_tarot, DailyTarotWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: DailyTarotWeb.ErrorHTML, json: DailyTarotWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: DailyTarot.PubSub,
  live_view: [signing_salt: "RdUTIIvr"]

config :daily_tarot, Oban,
  notifier: Oban.Notifiers.PG,
  repo: DailyTarot.Repo,
  queues: [default: 10],
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"0 17 * * *", DailyTarotJob.DailyWorker}
     ],
     timezone: "Etc/UTC"}
  ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :daily_tarot, DailyTarot.Mailer, adapter: Swoosh.Adapters.Local

# Removed due to using LiveSvelte
# Configure esbuild (the version is required)
# config :esbuild,
#   version: "0.20.2",
#   daily_tarot: [
#     args:
#       ~w(js/app.ts --bundle --format=esm --target=es2020 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
#     cd: Path.expand("../assets", __DIR__),
#     env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
#   ]

config :dart_sass,
  version: "1.72.0",
  default: [
    args: ~w(css/index.scss dist/_extra.css),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  app: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Timezone database
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
