defmodule LearnElixirGraphqlWeb.Resolvers.Preference do
  @moduledoc "User resolvers for Absinthe"
  use Absinthe.Schema.Notation
  alias EctoShorts.Actions
  alias LearnElixirGraphql.Accounts.Preference
  import Ecto.Query

  @type params :: keyword | map

  @spec all(params, any) :: {:ok, [Preference.t()]} | {:error, binary}
  def all(params, _) do
    # I wasnt able to make dialyzer accept the module as the first argument,
    # Actions.all(User, params) fails for me
    case Actions.all(from(p in Preference, preload: [:user]), params) do
      result when is_list(result) -> {:ok, result}
      other -> {:error, "An error occured: #{inspect(other)}"}
    end
  end

  @spec find(params, any) :: {:error, binary} | {:ok, Preference.t()}
  def find(params, _) do
    from(p in Preference) |> Actions.find(params)
  end

  @spec update(%{id: binary}, any) :: {:error, Ecto.Changeset.t()} | {:ok, Preference.t()}
  # dialyzer can't emotionally handle me using Actions.update(User, id, params)
  def update(%{id: id} = params, other) do
    with {:ok, preference} <- find(%{id: String.to_integer(id)}, other) do
      params = Map.delete(params, :id)
      Actions.update(Preference, preference, params)
    end
  end
end
