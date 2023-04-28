defmodule PDS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PDS.XRPC.Telemetry,
      # Start the Ecto repository
      PDS.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PDS.PubSub},
      # Start Finch
      {Finch, name: PDS.Finch},
      # Start the Endpoint (http/https)
      PDS.XRPC.Endpoint
      # Start a worker by calling: PDS.Worker.start_link(arg)
      # {PDS.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PDS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PDS.XRPC.Endpoint.config_change(changed, removed)
    :ok
  end
end
