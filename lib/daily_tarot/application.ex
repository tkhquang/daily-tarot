defmodule DailyTarot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {NodeJS.Supervisor, [path: LiveSvelte.SSR.NodeJS.server_path(), pool_size: 4]},
      DailyTarotWeb.Telemetry,
      DailyTarot.Repo,
      {Oban, Application.fetch_env!(:daily_tarot, Oban)},
      {DNSCluster, query: Application.get_env(:daily_tarot, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DailyTarot.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: DailyTarot.Finch},
      # Start a worker by calling: DailyTarot.Worker.start_link(arg)
      # {DailyTarot.Worker, arg},
      # Start to serve requests, typically the last entry
      DailyTarotWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DailyTarot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DailyTarotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
