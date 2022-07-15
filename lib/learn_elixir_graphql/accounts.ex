defmodule LearnElixirGraphql.Accounts do
  @moduledoc "The Accounts context, including Users and Preferences"
  alias EctoShorts.Actions
  alias LearnElixirGraphql.Accounts.{Preference, User}
  alias LearnElixirGraphql.ErrorUtils

  @type params :: map
  @type error :: %{code: atom, message: String.t(), details: map}
  @type changeset :: Ecto.Changeset.t()

  # USERS

  @spec all_users(params) :: [User.t()]
  def all_users(params) do
    Actions.all(User, params)
  end

  @spec all_user_ids :: {:ok, [pos_integer]}
  @spec all_user_ids(pid) :: {:ok, [pos_integer]}
  def all_user_ids(caller \\ self()) do
    Actions.all(User.select_id(), %{}, caller: caller)
  end

  @spec find_user(params) :: {:error, error} | {:ok, User.t()}
  def find_user(params) do
    Actions.find(User, params)
  rescue
    e -> ErrorUtils.internal_server_error_found(e, params)
  end

  @spec create_user(params) :: {:error, changeset} | {:ok, User.t()}
  def create_user(params) do
    Actions.create(User, params)
  rescue
    e -> ErrorUtils.internal_server_error_found(e, params)
  end

  @spec update_user(%{id: String.t()}) :: {:error, error | changeset} | {:ok, User.t()}
  def update_user(%{id: id} = params) do
    with {:ok, user} <- find_user(%{id: String.to_integer(id)}) do
      params = Map.delete(params, :id)
      Actions.update(User, user, params)
    end
  rescue
    e -> ErrorUtils.internal_server_error_found(e, params)
  end

  # PREFERENCES

  @spec all_preferences(params) :: {:ok, [Preference.t()]}
  def all_preferences(params) do
    {:ok, Actions.all(Preference, params)}
  end

  @spec find_preference(map) :: {:error, error} | {:ok, Preference.t()}
  def find_preference(params) do
    Actions.find(Preference, params)
  end

  @spec update_preference(params) :: {:error, error | changeset} | {:ok, Preference.t()}
  def update_preference(%{user_id: user_id} = params) do
    with {:ok, preference} <- find_preference(%{user_id: String.to_integer(user_id)}) do
      params = Map.delete(params, :user_id)
      Actions.update(Preference, preference, params)
    end
  rescue
    e -> ErrorUtils.internal_server_error_found(e, params)
  end
end
