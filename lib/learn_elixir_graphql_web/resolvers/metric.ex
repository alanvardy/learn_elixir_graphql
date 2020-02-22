defmodule LearnElixirGraphqlWeb.Resolvers.Metric do
  @moduledoc "User resolvers for Absinthe"
  use Absinthe.Schema.Notation
  alias LearnElixirGraphql.Metrics

  @type params :: keyword | map

  @spec find(params, any) :: {:ok, map}
  def find(%{key: key}, _) do
    Metrics.register_resolver_hit("resolver_hits")
    hits = Metrics.get_resolver_hits(key)
    {:ok, %{key: key, hits: hits}}
  end
end
