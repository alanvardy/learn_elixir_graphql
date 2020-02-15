defmodule LearnElixirGraphqlWeb.Resolvers.Preference do
  @moduledoc "User resolvers for Absinthe"
  use Absinthe.Schema.Notation
  alias LearnElixirGraphql.Accounts
  alias LearnElixirGraphql.Accounts.Preference

  @type params :: keyword | map

  @spec all(params, any) :: {:ok, [Preference.t()]} | {:error, binary}
  def all(params, _), do: Accounts.all_preferences(params)

  @spec find(params, any) :: {:error, binary} | {:ok, Preference.t()}
  def find(params, _), do: Accounts.find_preference(params)

  @spec update(params, any) :: {:error, Ecto.Changeset.t()} | {:ok, Preference.t()}
  def update(params, _), do: Accounts.update_preference(params)
end
