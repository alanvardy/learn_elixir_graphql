defmodule LearnElixirGraphql.Pipeline.Consumer do
  @moduledoc false

  use ConsumerSupervisor

  alias LearnElixirGraphql.Pipeline.{Processor, Producer}

  def start_link(args) do
    ConsumerSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    children = [%{id: Processor, start: {Processor, :start_link, []}, restart: :transient}]
    opts = [strategy: :one_for_one, subscribe_to: [{Producer, max_demand: 50}]]
    ConsumerSupervisor.init(children, opts)
  end
end
