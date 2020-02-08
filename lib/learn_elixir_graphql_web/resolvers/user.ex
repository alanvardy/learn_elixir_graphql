defmodule LearnElixirGraphqlWeb.Resolvers.User do
  @moduledoc "User resolvers for Absinthe"
  use Absinthe.Schema.Notation
  alias EctoShorts.Actions
  alias LearnElixirGraphql.Accounts.User
  import Ecto.Query

  @type params :: keyword | map

  @spec all(params, any) :: {:ok, [User.t()]} | {:error, binary}
  def all(params, _) do
    # I wasnt able to make dialyzer accept the module as the first argument,
    # Actions.all(User, params) fails for me
    case Actions.all(from(u in User, preload: [:preference]), params) do
      result when is_list(result) -> {:ok, result}
      other -> {:error, "An error occured: #{inspect(other)}"}
    end
  end

  @spec find(params, any) :: {:error, binary} | {:ok, User.t()}
  def find(params, _) do
    from(u in User) |> Actions.find(params)
  end

  @spec create(params, any) :: {:error, Ecto.Changeset.t()} | {:ok, User.t()}
  def create(params, _) do
    Actions.create(User, params)
  end

  @spec update(%{id: binary}, any) :: {:error, Ecto.Changeset.t()} | {:ok, User.t()}
  # dialyzer can't emotionally handle me using Actions.update(User, id, params)
  def update(%{id: id} = params, _) do
    with {:ok, user} <- find(%{id: String.to_integer(id)}, "nothing") do
      params = Map.delete(params, :id)
      Actions.update(User, user, params)
    end
  end
end
