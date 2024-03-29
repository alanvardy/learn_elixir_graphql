defmodule LearnElixirGraphql.Support.Helpers do
  @moduledoc "Helpers for tests"

  import ExUnit.Assertions
  alias LearnElixirGraphqlWeb.Schema

  @doc "Run a query against an Absinthe Schema, expecting no errors"
  @spec schema_success(String.t(), %{optional(String.t()) => any()}) :: map | nil
  def schema_success(document, variables) do
    {:ok, result} = Absinthe.run(document, Schema, variables: variables)
    refute Map.get(result, :errors)

    result
    |> Map.get(:data)
    |> tap(&assert/1)
  end

  @doc "Run a query against an Absinthe Schema, expecting errors and returning them"
  @spec schema_errors(String.t(), %{optional(String.t()) => any()}) :: [map]
  def schema_errors(document, variables) do
    {:ok, result} = Absinthe.run(document, Schema, variables: variables)

    result
    |> Map.get(:errors)
    |> tap(&assert/1)
  end

  @doc """
  Takes two data structures and attempts to normalize them for comparison
  i.e. change structs to maps, atom keys to string keys
  then runs assert
  """
  @spec assert_comparable(map, map) :: true
  def assert_comparable(left, right) do
    assert convert(left) === convert(right)
  end

  @bad_keys ["__meta__", "id", "user", "user_id", "inserted_at", "updated_at"]

  defp convert(struct) when is_struct(struct) do
    struct
    |> Map.from_struct()
    |> convert()
  end

  defp convert(map) when is_map(map) do
    map
    |> Stream.map(fn field -> string_keys(field) end)
    |> Stream.map(fn field -> map_or_list_values(field) end)
    |> Stream.reject(fn {key, _v} -> key in @bad_keys end)
    |> Enum.into(%{})
  end

  defp convert(value) do
    value
  end

  defp string_keys({key, value}) when is_atom(key), do: {Atom.to_string(key), value}
  defp string_keys({key, value}), do: {key, value}

  defp map_or_list_values({key, values}) when is_list(values),
    do: {key, Enum.map(values, fn value -> convert(value) end)}

  defp map_or_list_values({key, value}) when is_map(value), do: {key, convert(value)}
  defp map_or_list_values({key, value}), do: {key, value}
end
