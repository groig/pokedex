defmodule Pokedex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Pokedex.Repo,
      # Start the Telemetry supervisor
      PokedexWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Pokedex.PubSub},
      # Start the Endpoint (http/https)
      PokedexWeb.Endpoint,
      # Start a worker by calling: Pokedex.Worker.start_link(arg)
      # {Pokedex.Worker, arg}
      Pokedex.State
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pokedex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PokedexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
