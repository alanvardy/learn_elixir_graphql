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
    {:producer, %{demand: 0, caller: caller}}
  end

  @impl GenStage
  def handle_demand(demand, state) when demand > 0 do
    fetch_and_return_tokens(demand, state)
  end

  @impl GenStage
  def handle_info(:recheck, state) do
    Process.send_after(self(), :recheck, @recheck_interval)

    fetch_and_return_tokens(0, state)
  end

  defp fetch_and_return_tokens(demand, %{demand: previous_demand, caller: caller}) do
    demand = demand + previous_demand

    token_tuples =
      demand
      |> Accounts.all_expired_tokens(caller)
      |> Enum.map(&{&1, caller})

    new_demand = demand - Enum.count(token_tuples)

    {:noreply, token_tuples, %{demand: new_demand, caller: caller}}
  end
end
