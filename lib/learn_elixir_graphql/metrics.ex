defmodule LearnElixirGraphql.Metrics do
  @moduledoc "The metrics context"
  alias LearnElixirGraphql.Metrics.HitTracker

  @spec get_resolver_hits(binary) :: non_neg_integer
  def get_resolver_hits(key) do
    HitTracker.get(key)
  end

  @spec register_resolver_hit(binary) :: :ok
  def register_resolver_hit(key) do
    HitTracker.increment(key)
  end
end
