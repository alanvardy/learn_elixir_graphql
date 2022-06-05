defmodule LearnElixirGraphql.Accounts do
  @moduledoc "The Accounts context, including Users and Preferences"
  alias EctoShorts.Actions
  alias LearnElixirGraphql.Accounts.{Preference, Token, User}
  alias LearnElixirGraphql.ErrorUtils
  alias LearnElixirGraphql.Repo

  @type params :: map
  @type error :: %{code: atom, message: String.t(), details: map}
  @type changeset :: Ecto.Changeset.t()

  # USERS

  @spec all_users(params) :: {:ok, [User.t()]}
  def all_users(params) do
    {:ok, Actions.all(User, params)}
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

  # TOKEN

  @spec find_token(params) :: {:error, error} | {:ok, Token.t()}
  def find_token(params) do
    Actions.find(Token, params)
  rescue
    e -> ErrorUtils.internal_server_error_found(e, params)
  end

  @spec update_token(map) :: {:error, error | changeset} | {:ok, Token.t()}
  def update_token(%{id: id} = params) do
    with {:ok, auth} <- find_token(%{id: String.to_integer(id)}) do
      params = Map.delete(params, :id)
      Actions.update(Token, auth, params)
    end
  rescue
    e -> ErrorUtils.internal_server_error_found(e, params)
  end

  @spec update_token(pos_integer, map) :: {:error, error | changeset} | {:ok, Token.t()}
  def update_token(id, updates, caller \\ self()) do
    Actions.update(Token, id, updates, caller: caller)
  end

  def all_expired_tokens(limit, caller \\ self()) do
    limit
    |> Token.limit()
    |> Token.where_expired()
    |> Repo.all(caller: caller)
  end

  def refresh_token(%Token{id: id}, caller \\ self()) do
    update_token(id, %{token: generate_token()}, caller)
  end

  def generate_token do
    Base.encode32(:crypto.strong_rand_bytes(50), padding: false)
  end
end
