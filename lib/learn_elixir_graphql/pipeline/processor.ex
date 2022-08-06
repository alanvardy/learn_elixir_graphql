defmodule LearnElixirGraphql.Pipeline.Processor do
  @moduledoc """
  Regenerates auth tokens
  """

  alias LearnElixirGraphql.{Config, TokenCache}

  # One hour before expiry
  @max_age Config.token_max_age() - 60_000

  @doc "Checks a users token and recreates if expired or does not exist"
  @spec start_link(pos_integer) :: {:ok, pid}
  def start_link(user_id) do
    # Note: this function must return the format of `{:ok, pid}` and like
    # all children started by a Supervisor, the process must be linked
    # back to the supervisor (if you use `Task.start_link/1` then both
    # these requirements are met automatically)
    Task.start_link(fn ->
      case TokenCache.check_token(user_id, @max_age) do
        {:error, :expired} -> TokenCache.set_cluster_tokens(user_id)
        {:error, :not_found} -> TokenCache.set_cluster_tokens(user_id)
        {:ok, _token} -> :ok
      end
    end)
  end
end
