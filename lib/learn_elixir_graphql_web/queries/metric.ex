defmodule LearnElixirGraphqlWeb.Queries.Metric do
  @moduledoc "Absinthe queries for metrics"
  use Absinthe.Schema.Notation
  alias LearnElixirGraphqlWeb.Resolvers

  object :metric_queries do
    field :resolver_hits, :resolver_hit do
      arg :key, :string
      resolve &Resolvers.Metric.find/2
    end
  end
end
