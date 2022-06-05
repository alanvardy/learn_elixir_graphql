defmodule LearnElixirGraphql.Pipeline.Supervisor do
  @moduledoc "Started once per region, supervises multiple match consumers"
  use Supervisor
  alias LearnElixirGraphql.Pipeline.{Consumer, Producer}

  def start_link(args) do
    caller = Keyword.fetch!(args, :caller)
    Supervisor.start_link(__MODULE__, [caller: caller], name: __MODULE__)
  end

  @impl Supervisor
  def init(args) do
    caller = Keyword.fetch!(args, :caller)

    Supervisor.init([{Producer, caller: caller}, Consumer], strategy: :rest_for_one)
  end

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]},
      type: :supervisor
    }
  end
end
