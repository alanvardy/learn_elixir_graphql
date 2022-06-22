defmodule LearnElixirGraphql.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias LearnElixirGraphql.Metrics.HitTracker

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    HitTracker.start()
    # List all child processes to be supervised
    children =
      [
        # Start the endpoint when the application starts
        {Phoenix.PubSub, [name: LearnElixirGraphql.PubSub, adapter: Phoenix.PubSub.PG2]},
        LearnElixirGraphqlWeb.Endpoint,
        {Absinthe.Subscription, [LearnElixirGraphqlWeb.Endpoint]},
        {LearnElixirGraphql.Repo, []},
        LearnElixirGraphql.TokenCache

        # Starts a worker by calling: LearnElixirGraphql.Worker.start_link(arg)
        # {LearnElixirGraphql.Worker, arg},
      ] ++ pipeline_supervisor()

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

  if Mix.env() !== :test do
    defp pipeline_supervisor, do: [{LearnElixirGraphql.Pipeline.Supervisor, caller: self()}]
  else
    defp pipeline_supervisor, do: []
  end
end
