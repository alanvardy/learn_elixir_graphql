defmodule LearnElixirGraphqlWeb.Types.Metric do
  @moduledoc "Metric types for Absinthe"
  use Absinthe.Schema.Notation

  alias LearnElixirGraphql.Metrics.HitTracker

  @desc "The number of times a resolver has his a particular key"
  object :resolver_hit do
    field :key, non_null(:metric_key)
    field :hits, non_null(:integer)
  end

  enum :metric_key, values: HitTracker.keys()
end
