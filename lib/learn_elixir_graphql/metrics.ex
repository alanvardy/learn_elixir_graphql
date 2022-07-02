defmodule LearnElixirGraphql.Metrics do
  @moduledoc "The metrics context"
  alias LearnElixirGraphql.Metrics.HitTracker

  @type key :: LearnElixirGraphql.Metrics.HitTracker.key()

  @spec get_cluster_resolver_hits(key) :: non_neg_integer
  def get_cluster_resolver_hits(key) do
    {hits, _bad_nodes} = :rpc.multicall(HitTracker, :get, [key])

    hits |> Enum.sum() |> round()
  end

  @spec get_resolver_hits(key) :: non_neg_integer
  defdelegate get_resolver_hits(key), to: HitTracker, as: :get

  @spec register_resolver_hit(key) :: :ok
  defdelegate register_resolver_hit(key), to: HitTracker, as: :increment
end
