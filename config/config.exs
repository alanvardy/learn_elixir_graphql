# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :learn_elixir_graphql, LearnElixirGraphql.Repo,
  database: "learn_elixir_graphql_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5432

# Configures the endpoint
config :learn_elixir_graphql, LearnElixirGraphqlWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ykF4evjNQvlluKda+Bn/JR8AcXn1zpFdbOnAhsFhoIb38A1Kp8L/mlPZEWJdQexF",
  render_errors: [view: LearnElixirGraphqlWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: LearnElixirGraphql.PubSub

config :learn_elixir_graphql,
  ecto_repos: [LearnElixirGraphql.Repo],
  token_max_age: :timer.hours(24),
  pipeline_recheck_interval: :timer.seconds(30)

config :ecto_shorts,
  repo: LearnElixirGraphql.Repo,
  error_module: EctoShorts.Actions.Error

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
