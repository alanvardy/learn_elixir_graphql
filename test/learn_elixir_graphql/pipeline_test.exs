defmodule LearnElixirGraphql.PipelineTest do
  use LearnElixirGraphql.DataCase, async: true

  import LearnElixirGraphql.Support.TestSetup

  alias LearnElixirGraphql.Accounts.Token

  # TODO use config
  @max_age :timer.hours(26)
  @sleep 100

  describe "pipeline" do
    setup :user

    setup do
      start_supervised!({LearnElixirGraphql.Pipeline.Supervisor, caller: self()})
      :ok
    end

    test "updates user token when expired" do
      assert [%{token: "ABCD"}] = Repo.all(Token)

      one_day_ago = DateTime.utc_now() |> DateTime.add(-@max_age, :millisecond)

      Repo.update_all(Token, set: [updated_at: one_day_ago])

      Process.sleep(@sleep)

      assert [%{token: token}] = Repo.all(Token)
      assert token !== "ABCD"

      stop_supervised!(LearnElixirGraphql.Pipeline.Supervisor)
    end

    test "does not update user token when not expired" do
      assert [%{token: "ABCD", updated_at: updated_at}] = Repo.all(Token)

      Process.sleep(@sleep)

      assert [%{token: "ABCD", updated_at: ^updated_at}] = Repo.all(Token)

      stop_supervised!(LearnElixirGraphql.Pipeline.Supervisor)
    end
  end
end
