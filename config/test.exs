use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :learn_elixir_graphql, LearnElixirGraphqlWeb.Endpoint,
  http: [port: 4002],
  server: false

config :learn_elixir_graphql, LearnElixirGraphql.Repo,
  username: "postgres",
  password: "postgres",
  database: "learn_elixir_graphql_test",
  hostname: "localhost",
  queue_target: 10_000,
  pool: Ecto.Adapters.SQL.Sandbox

config :learn_elixir_graphql, token: "faketoken"

# Print only warnings and errors during test
config :logger, level: :warn
