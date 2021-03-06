defmodule LearnElixirGraphql.Metrics do
  @moduledoc "The metrics context"
  alias LearnElixirGraphql.Metrics.HitTracker

  @spec get_resolver_hits(binary) :: non_neg_integer
  defdelegate get_resolver_hits(key), to: HitTracker, as: :get

  @spec register_resolver_hit(binary) :: :ok
  defdelegate register_resolver_hit(key), to: HitTracker, as: :increment
end
