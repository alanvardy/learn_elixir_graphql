defmodule LearnElixirGraphqlWeb.Resolvers.User do
  @moduledoc "User resolvers for Absinthe"
  use Absinthe.Schema.Notation
  alias LearnElixirGraphql.Accounts.User

  @type params :: keyword | map

  @spec all(params, any) :: {:ok, [User.t()]} | {:error, binary}
  def all(params, _), do: User.all(params)

  @spec find(params, any) :: {:error, binary} | {:ok, User.t()}
  def find(params, _), do: User.find(params)

  @spec create(params, any) :: {:error, Ecto.Changeset.t()} | {:ok, User.t()}
  def create(params, _), do: User.create(params)

  @spec update(params, any) :: {:error, Ecto.Changeset.t()} | {:ok, User.t()}
  # dialyzer can't emotionally handle me using Actions.update(User, id, params)
  def update(params, _), do: User.update(params)
end
