defmodule LearnElixirGraphqlWeb.Resolvers.User do
  @moduledoc "User resolvers for Absinthe"
  use Absinthe.Schema.Notation
  alias LearnElixirGraphql.{Accounts, Metrics}
  alias LearnElixirGraphql.Accounts.User

  @type params :: keyword | map

  @spec all(params, any) :: {:ok, [User.t()]} | {:error, binary}
  def all(params, _) do
    Metrics.register_resolver_hit("users")
    Accounts.all_users(params)
  end

  @spec find(params, any) :: {:error, binary} | {:ok, User.t()}
  def find(params, _) do
    Metrics.register_resolver_hit("user")
    Accounts.find_user(params)
  end

  @spec create(params, any) :: {:error, Ecto.Changeset.t()} | {:ok, User.t()}
  def create(params, _) do
    Metrics.register_resolver_hit("create_user")
    Accounts.create_user(params)
  end

  @spec update(params, any) :: {:error, Ecto.Changeset.t()} | {:ok, User.t()}
  def update(params, _) do
    Metrics.register_resolver_hit("update_user")
    Accounts.update_user(params)
  end
end
