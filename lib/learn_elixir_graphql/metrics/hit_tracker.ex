defmodule LearnElixirGraphql.Metrics.HitTracker do
  @moduledoc "Process which keeps track of the number of times any particular resolver has been hit"
  use GenServer

  # Client

  @spec start_link(maybe_improper_list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  @spec increment(binary) :: :ok
  def increment(key) do
    GenServer.cast(__MODULE__, {:increment, key})
  end

  @spec get(binary) :: non_neg_integer
  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  # Server

  @impl true
  @spec init(any) :: {:ok, %{}}
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:increment, key}, state) do
    {:noreply, Map.update(state, key, 1, &(&1 + 1))}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key, 0), state}
  end
end
