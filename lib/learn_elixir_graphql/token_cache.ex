defmodule LearnElixirGraphql.TokenCache do
  @moduledoc """
  ETS table for holding tokens and their time of creation
  """
  use GenServer

  alias LearnElixirGraphql.Config

  @cache_name :token_cache
  @max_age Config.token_max_age()

  @type id :: pos_integer
  @type token :: String.t()
  @type age :: pos_integer

  @spec start_link(any) :: GenServer.on_start()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc false
  @impl GenServer
  def init(opts) do
    :ets.new(@cache_name, [:named_table, :public, :set])
    {:ok, opts}
  end

  @doc "Get token from cache if still valid"
  @spec check_token(id) :: {:ok, token} | {:error, :expired | :not_found}
  @spec check_token(id, age) :: {:ok, token} | {:error, :expired | :not_found}
  def check_token(user_id, max_age \\ @max_age) do
    with {:ok, token, datetime} <- get_token(user_id) do
      if expired?(datetime, max_age) do
        {:error, :expired}
      else
        {:ok, token}
      end
    end
  end

  @doc "Returns true if datetime is older than age in milliseconds"
  @spec expired?(DateTime.t(), age) :: boolean
  def expired?(datetime, max_age) do
    DateTime.utc_now()
    |> DateTime.add(-max_age, :millisecond)
    |> DateTime.compare(datetime)
    |> Kernel.===(:gt)
  end

  @doc "Get token and datetime from cache"
  @spec get_token(id) :: {:ok, token, DateTime.t()} | {:error, :not_found}
  def get_token(user_id) do
    {token, datetime} = :ets.lookup_element(@cache_name, user_id, 2)
    {:ok, token, datetime}
  rescue
    _ -> {:error, :not_found}
  end

  @doc "Create a token and put into cache"
  @spec set_token(id) :: :ok
  @spec set_token(id, token) :: :ok
  @spec set_token(id, token, DateTime.t()) :: :ok
  def set_token(user_id, token \\ generate_token(), datetime \\ DateTime.utc_now()) do
    :ets.insert(@cache_name, {user_id, {token, datetime}})

    :ok
  end

  @doc "Generate a random string"
  @spec generate_token :: token
  def generate_token do
    Base.encode32(:crypto.strong_rand_bytes(50), padding: false)
  end
end
