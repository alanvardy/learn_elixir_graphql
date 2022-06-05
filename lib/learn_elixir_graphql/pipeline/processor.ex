defmodule LearnElixirGraphql.Pipeline.Processor do
  @moduledoc """
  Regenerates auth tokens
  """

  alias LearnElixirGraphql.Accounts

  def start_link({token, caller}) do
    # Note: this function must return the format of `{:ok, pid}` and like
    # all children started by a Supervisor, the process must be linked
    # back to the supervisor (if you use `Task.start_link/1` then both
    # these requirements are met automatically)
    Task.start_link(fn ->
      Accounts.refresh_token(token, caller)
    end)
  end
end
