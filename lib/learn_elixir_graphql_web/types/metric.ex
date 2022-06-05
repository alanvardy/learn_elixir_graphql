defmodule LearnElixirGraphqlWeb.Types.Metric do
  @moduledoc "Metric types for Absinthe"
  use Absinthe.Schema.Notation

  alias LearnElixirGraphql.Metrics.HitTracker

  @desc "The number of times a resolver has his a particular key"
  object :resolver_hit do
    field :key, :metric_key
    field :hits, :integer
  end

  enum :metric_key, values: HitTracker.keys()
end
