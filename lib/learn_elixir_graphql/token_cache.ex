defmodule LearnElixirGraphql.TokenCache do
  use GenServer

  alias LearnElixirGraphql.Config

  @cache_name :token_cache
  @max_age Config.token_max_age()

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    :ets.new(@cache_name, [:named_table, :public, :set])
    {:ok, opts}
  end

  def check_token(user_id, max_age \\ @max_age) do
    with {:ok, token, datetime} <- get_token(user_id) do
      if expired?(datetime, max_age) do
        {:error, :expired}
      else
        {:ok, token}
      end
    end
  end

  def expired?(datetime, max_age) do
    DateTime.utc_now()
    |> DateTime.add(-max_age, :millisecond)
    |> DateTime.compare(datetime)
    |> Kernel.===(:gt)
  end

  def get_token(user_id) do
    {token, datetime} = :ets.lookup_element(@cache_name, user_id, 2)
    {:ok, token, datetime}
  rescue
    _ -> {:error, :not_found}
  end

  def set_token(user_id, token \\ generate_token(), datetime \\ DateTime.utc_now()) do
    :ets.insert(@cache_name, {user_id, {token, datetime}})

    :ok
  end

  def generate_token do
    Base.encode32(:crypto.strong_rand_bytes(50), padding: false)
  end
end
