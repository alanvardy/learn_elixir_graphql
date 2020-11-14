defmodule LearnElixirGraphql.Helpers do
  @moduledoc "Helpers for tests"

  import ExUnit.Assertions
  alias LearnElixirGraphql.Accounts
  alias LearnElixirGraphqlWeb.Schema

  @doc "Run a query and return data"
  @spec run_schema(String.t(), %{optional(String.t()) => any()}) :: {:ok, map}
  def run_schema(document, variables) do
    assert {:ok, %{data: data}} = Absinthe.run(document, Schema, variables: variables)
    data
  end

  @doc "Run a query against an Absinthe Schema, expecting no errors"
  @spec schema_success(String.t(), %{optional(String.t()) => any()}) :: map
  def schema_success(document, variables) do
    {:ok, result} = Absinthe.run(document, Schema, variables: variables)
    refute Map.get(result, :errors)
    data = Map.get(result, :data)
    assert data
    data
  end

  @doc "Run a query against an Absinthe Schema, expecting errors and returning them"
  @spec schema_errors(String.t(), %{optional(String.t()) => any()}) :: [map | tuple]
  def schema_errors(document, variables) do
    assert {:ok, %{errors: errors}} = Absinthe.run(document, Schema, variables: variables)
    errors
  end


  @doc "Creates users for a list of maps containing the paramers"
  @spec create_users([map]) :: [User.t()]
  def create_users(users_params) do
    for params <- users_params, do: create_user(params)
  end

  @doc "Creates a user from a map of parameters"
  @spec create_user(map) :: User.t()
  def create_user(user_params) do
    {:ok, user} = Accounts.create_user(user_params)
    user
  end

  @doc """
  Takes two data structures and attempts to normalize them for comparison
  i.e. change structs to maps, atom keys to string keys
  then runs assert
  """
  @spec assert_comparable(any, any) :: none
  def assert_comparable(left, right) do
    assert convert(left) == convert(right)
  end

  @bad_keys ["__meta__", "id", "user", "user_id"]

  defp convert(struct) when is_struct(struct) do
    struct
    |> Map.from_struct()
    |> convert()
  end

  defp convert(map) when is_map(map) do
    map
    |> Enum.map(fn field -> string_keys(field) end)
    |> Enum.map(fn field -> map_or_list_values(field) end)
    |> Enum.reject(fn {key, _v} -> key in @bad_keys end)
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
