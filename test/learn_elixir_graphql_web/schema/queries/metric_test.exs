defmodule LearnElixirGraphqlWeb.Schema.Queries.MetricTest do
  use LearnElixirGraphql.DataCase

  alias LearnElixirGraphql.Support.Helpers

  @user_doc """
    query findUser($name: String, $email: String) {
      user(name: $name, email: $email) {
        id,
        name,
        email
      }
    }
  """

  @resolver_hits_doc """
    query resolverHits($key: MetricKey) {
      resolver_hits(key: $key) {
        key,
        hits
      }
    }
  """

  describe "@resolver_hits" do
    test "Will record user queries" do
      first_count =
        @resolver_hits_doc
        |> Helpers.schema_success(%{"key" => "USER"})
        |> get_in(["resolver_hits", "hits"])

      Helpers.schema_errors(@user_doc, %{"name" => "Nancy"})

      second_count =
        @resolver_hits_doc
        |> Helpers.schema_success(%{"key" => "USER"})
        |> get_in(["resolver_hits", "hits"])

      assert second_count == first_count + 1
    end

    test "Records itself" do
      [first, second, third] =
        for _num <- 1..3 do
          @resolver_hits_doc
          |> Helpers.schema_success(%{"key" => "RESOLVER_HITS"})
          |> get_in(["resolver_hits", "hits"])
        end

      assert second == first + 1
      assert third == second + 1
    end
  end
end
