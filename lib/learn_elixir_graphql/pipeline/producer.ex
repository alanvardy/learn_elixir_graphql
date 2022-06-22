defmodule LearnElixirGraphql.Pipeline.Producer do
  @moduledoc """
  Finds expired auth tokens
  """
  use GenStage

  alias LearnElixirGraphql.{Accounts, Config}

  @recheck_interval Config.pipeline_recheck_interval()

  def start_link(args) do
    caller = Keyword.fetch!(args, :caller)
    GenStage.start_link(__MODULE__, [caller: caller], name: __MODULE__)
  end

  @impl GenStage
  def init(args) do
    caller = Keyword.fetch!(args, :caller)
    Process.send_after(self(), :recheck, @recheck_interval)
    {:producer, %{demand: 0, caller: caller, user_ids: []}}
  end

  @impl GenStage
  def handle_demand(demand, state) when demand > 0 do
    return_user_ids(demand, state)
  end

  @impl GenStage
  def handle_info(:recheck, %{caller: caller} = state) do
    Process.send_after(self(), :recheck, @recheck_interval)

    state = Map.put(state, :user_ids, Accounts.all_user_ids(caller))

    return_user_ids(0, state)
  end

  defp return_user_ids(demand, %{user_ids: user_ids, demand: prev_demand, caller: caller}) do
    demand = demand + prev_demand
    {user_ids_for_consumers, user_ids} = Enum.split(user_ids, demand)
    new_demand = demand - Enum.count(user_ids_for_consumers)

    {:noreply, user_ids_for_consumers, %{demand: new_demand, caller: caller, user_ids: user_ids}}
  end
end
