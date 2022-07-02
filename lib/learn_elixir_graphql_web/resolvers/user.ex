defmodule LearnElixirGraphqlWeb.Resolvers.User do
  @moduledoc "User resolvers for Absinthe"
  use Absinthe.Schema.Notation
  alias LearnElixirGraphql.{Accounts, Metrics, TokenCache}
  alias LearnElixirGraphql.Accounts.User

  @type params :: map
  @type error :: Accounts.error()
  @type changeset :: Ecto.Changeset.t()

  @spec all(params, any) :: {:ok, [map]}
  def all(params, _) do
    Metrics.register_resolver_hit(:users)

    params
    |> Accounts.all_users()
    |> Enum.map(&add_token/1)
    |> then(&{:ok, &1})
  end

  @spec find(params, any) :: {:error, error} | {:ok, map}
  def find(params, _) do
    Metrics.register_resolver_hit(:user)

    with {:ok, user} <- Accounts.find_user(params) do
      {:ok, add_token(user)}
    end
  end

  @spec create(params, any) :: {:error, changeset} | {:ok, User.t()}
  def create(params, _) do
    Metrics.register_resolver_hit(:create_user)
    Accounts.create_user(params)
  end

  @spec update(params, any) :: {:error, changeset | error} | {:ok, User.t()}
  def update(params, _) do
    Metrics.register_resolver_hit(:update_user)
    Accounts.update_user(params)
  end

  defp add_token(%User{id: id} = user) do
    token =
      case TokenCache.check_token(id) do
        {:ok, token} -> token
        {:error, _} -> TokenCache.set_token(id)
      end

    user
    |> Map.from_struct()
    |> Map.put(:auth_token, token)
  end
end
