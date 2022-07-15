defmodule LearnElixirGraphqlWeb.Resolvers.User do
  @moduledoc "User resolvers for Absinthe"
  use Absinthe.Schema.Notation
  alias LearnElixirGraphql.{Accounts, Metrics, TokenCache}
  alias LearnElixirGraphql.Accounts.User

  @type params :: map
  @type error :: Accounts.error()
  @type changeset :: Ecto.Changeset.t()
  @type token :: String.t()
  @type resolution :: Absinthe.Resolution.t()

  @spec all(params, resolution) :: {:ok, [User.t()]}
  def all(params, _) do
    Metrics.register_resolver_hit(:users)

    params
    |> Accounts.all_users()
    |> then(&{:ok, &1})
  end

  @spec find(params, resolution) :: {:error, error} | {:ok, User.t()}
  def find(params, _) do
    Metrics.register_resolver_hit(:user)

    Accounts.find_user(params)
  end

  @spec create(params, resolution) :: {:error, changeset} | {:ok, User.t()}
  def create(params, _) do
    Metrics.register_resolver_hit(:create_user)
    Accounts.create_user(params)
  end

  @spec update(params, resolution) :: {:error, changeset | error} | {:ok, User.t()}
  def update(params, _) do
    Metrics.register_resolver_hit(:update_user)
    Accounts.update_user(params)
  end

  @spec find_auth_token(User.t(), params, resolution) :: {:ok, token}
  def find_auth_token(%User{id: id}, _, _res) do
    with {:error, _} <- TokenCache.check_token(id) do
      {:ok, TokenCache.set_token(id)}
    end
  end
end
