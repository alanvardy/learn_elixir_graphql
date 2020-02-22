defmodule LearnElixirGraphqlWeb.Resolvers.Preference do
  @moduledoc "User resolvers for Absinthe"
  use Absinthe.Schema.Notation
  alias LearnElixirGraphql.{Accounts, Metrics}
  alias LearnElixirGraphql.Accounts.Preference

  @type params :: keyword | map

  @spec all(params, any) :: {:ok, [Preference.t()]} | {:error, binary}
  def all(params, _) do
    Metrics.register_resolver_hit("preferences")
    Accounts.all_preferences(params)
  end

  @spec find(params, any) :: {:error, binary} | {:ok, Preference.t()}
  def find(params, _) do
    Metrics.register_resolver_hit("preference")
    Accounts.find_preference(params)
  end

  @spec update(params, any) :: {:error, Ecto.Changeset.t()} | {:ok, Preference.t()}
  def update(params, _) do
    Metrics.register_resolver_hit("update_preference")
    Accounts.update_preference(params)
  end
end
