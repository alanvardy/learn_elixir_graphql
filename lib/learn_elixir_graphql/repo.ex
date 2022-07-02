defmodule LearnElixirGraphql.Repo do
  @moduledoc "Database"
  use Ecto.Repo,
    otp_app: :learn_elixir_graphql,
    adapter: Ecto.Adapters.Postgres
end
