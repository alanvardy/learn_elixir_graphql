defmodule LearnElixirGraphql.Metrics.HitTracker do
  @moduledoc """
  Uses Erlang :counter to keep track of the number of times
  any particular resolver has been hit. Reference to counter
  array is stored in :persistent_term for fast concurrent access.
  https://www.erlang.org/blog/persistent_term/

  Deploying resets counters, should work multi-node.
  """

  @name :counter

  @type key ::
          :create_user
          | :preference
          | :preferences
          | :resolver_hits
          | :update_preference
          | :update_user
          | :user
          | :users

  @keys [
    :create_user,
    :preference,
    :preferences,
    :resolver_hits,
    :update_preference,
    :update_user,
    :user,
    :users
  ]

  @spec start :: :ok
  def start do
    @keys
    |> Enum.count()
    |> :counters.new([:write_concurrency])
    |> then(&:persistent_term.put(@name, &1))
  end

  @spec increment(key) :: :ok
  def increment(key) when key in @keys do
    index = get_index(key)

    @name
    |> :persistent_term.get()
    |> :counters.add(index, 1)
  end

  @spec get(key) :: non_neg_integer
  def get(key) when key in @keys do
    index = get_index(key)

    @name
    |> :persistent_term.get()
    |> :counters.get(index)
  end

  def keys, do: @keys

  defp get_index(key), do: Enum.find_index(@keys, &(&1 === key)) + 1
end
