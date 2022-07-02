defmodule LearnElixirGraphql.PipelineTest do
  use LearnElixirGraphql.DataCase, async: true

  import LearnElixirGraphql.Support.TestSetup, only: [user: 1]

  alias LearnElixirGraphql.{Config, TokenCache}

  @max_age Config.token_max_age() + :timer.minutes(1)
  @sleep 500

  describe "pipeline" do
    setup :user

    test "updates user token when expired", %{user: user} do
      TokenCache.set_token(
        user.id,
        "OLDTOKEN",
        DateTime.add(DateTime.utc_now(), -@max_age, :millisecond)
      )

      assert {:ok, "OLDTOKEN", %DateTime{} = old_datetime} = TokenCache.get_token(user.id)

      start_supervised!({LearnElixirGraphql.Pipeline.Supervisor, caller: self()})
      Process.sleep(@sleep)
      assert {:ok, token, %DateTime{} = new_datetime} = TokenCache.get_token(user.id)
      refute token === "OLDTOKEN"
      assert DateTime.compare(new_datetime, old_datetime) === :gt
      stop_supervised!(LearnElixirGraphql.Pipeline.Supervisor)
    end

    test "does not update token when not expired", %{user: user} do
      TokenCache.set_token(
        user.id,
        "OLDTOKEN"
      )

      assert {:ok, "OLDTOKEN", %DateTime{} = datetime} = TokenCache.get_token(user.id)

      start_supervised!({LearnElixirGraphql.Pipeline.Supervisor, caller: self()})
      Process.sleep(@sleep)
      assert {:ok, "OLDTOKEN", ^datetime} = TokenCache.get_token(user.id)
      stop_supervised!(LearnElixirGraphql.Pipeline.Supervisor)
    end
  end
end
