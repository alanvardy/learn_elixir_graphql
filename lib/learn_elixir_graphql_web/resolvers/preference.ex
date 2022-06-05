defmodule LearnElixirGraphqlWeb.Resolvers.Preference do
  @moduledoc "User resolvers for Absinthe"
  use Absinthe.Schema.Notation
  alias LearnElixirGraphql.{Accounts, Metrics}
  alias LearnElixirGraphql.Accounts.Preference

  @type params :: map
  @type error :: Accounts.error()
  @type changeset :: Ecto.Changeset.t()

  @spec all(params, any) :: {:ok, [Preference.t()]}
  def all(params, _) do
    Metrics.register_resolver_hit(:preferences)
    Accounts.all_preferences(params)
  end

  @spec find(params, any) :: {:error, error} | {:ok, Preference.t()}
  def find(params, _) do
    Metrics.register_resolver_hit(:preference)
    Accounts.find_preference(params)
  end

  @spec update(params, any) :: {:error, error | changeset} | {:ok, Preference.t()}
  def update(params, _) do
    Metrics.register_resolver_hit(:update_preference)
    Accounts.update_preference(params)
  end
end
