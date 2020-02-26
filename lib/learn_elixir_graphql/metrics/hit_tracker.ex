defmodule LearnElixirGraphql.Metrics.HitTracker do
  @moduledoc "Process which keeps track of the number of times any particular resolver has been hit"
  use Agent

  @spec start_link(maybe_improper_list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec increment(binary) :: :ok
  def increment(key) do
    Agent.update(__MODULE__, fn state -> Map.update(state, key, 1, &(&1 + 1)) end)
  end

  @spec get(binary) :: non_neg_integer
  def get(key) do
    Agent.get(__MODULE__, fn state -> Map.get(state, key, 0) end)
  end
end
