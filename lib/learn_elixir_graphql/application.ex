defmodule LearnElixirGraphql.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      LearnElixirGraphqlWeb.Endpoint,
      LearnElixirGraphql.Metrics.HitTracker,
      {Absinthe.Subscription, [LearnElixirGraphqlWeb.Endpoint]},
      {LearnElixirGraphql.Repo, []}
      # Starts a worker by calling: LearnElixirGraphql.Worker.start_link(arg)
      # {LearnElixirGraphql.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LearnElixirGraphql.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @spec config_change(any, any, any) :: :ok
  def config_change(changed, _new, removed) do
    LearnElixirGraphqlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
