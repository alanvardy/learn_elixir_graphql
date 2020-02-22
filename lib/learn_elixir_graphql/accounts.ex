defmodule LearnElixirGraphql.Accounts do
  @moduledoc "The Accounts context, including Users and Preferences"
  alias EctoShorts.Actions
  alias LearnElixirGraphql.Accounts.{Preference, User}
  import Ecto.Query

  @type params :: keyword | map

  # USERS

  @spec all_users(params) :: {:ok, [User.t()]} | {:error, binary}
  def all_users(params) do
    result = Actions.all(from(u in User), params)
    {:ok, result}
  end

  @spec find_user(params) :: {:error, binary} | {:ok, User.t()}
  def find_user(params) do
    from(u in User) |> Actions.find(params)
  end

  @spec create_user(params) :: {:error, Ecto.Changeset.t()} | {:ok, User.t()}
  def create_user(params) do
    Actions.create(User, params)
  end

  @spec update_user(%{id: binary}) :: {:error, Ecto.Changeset.t()} | {:ok, User.t()}
  def update_user(%{id: id} = params) do
    with {:ok, user} <- find_user(%{id: String.to_integer(id)}) do
      params = Map.delete(params, :id)
      Actions.update(User, user, params)
    end
  end

  # PREFERENCES

  @spec all_preferences(params) :: {:ok, [Preference.t()]} | {:error, binary}
  def all_preferences(params) do
    result = Actions.all(from(p in Preference), params)
    {:ok, result}
  end

  @spec find_preference(params) :: {:error, binary} | {:ok, Preference.t()}
  def find_preference(params) do
    from(p in Preference) |> Actions.find(params)
  end

  @spec update_preference(params) :: {:error, Ecto.Changeset.t()} | {:ok, Preference.t()}
  def update_preference(%{user_id: user_id} = params) do
    with {:ok, preference} <- find_preference(%{user_id: String.to_integer(user_id)}) do
      params = Map.delete(params, :user_id)
      Actions.update(Preference, preference, params)
    end
  end
end
