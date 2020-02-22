defmodule LearnElixirGraphqlWeb.Schema.Queries.MetricTest do
  use LearnElixirGraphql.DataCase
  alias LearnElixirGraphqlWeb.Schema

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
    query resolverHits($key: String) {
      resolver_hits(key: $key) {
        key,
        hits
      }
    }
  """

  describe "@resolver_hits" do
    test "Will record user queries" do
      assert {:ok, %{data: data}} =
               Absinthe.run(@resolver_hits_doc, Schema, variables: %{"key" => "user"})

      first_count = get_in(data, ["resolver_hits", "hits"])

      assert {:ok, %{data: data}} =
               Absinthe.run(@user_doc, Schema, variables: %{"name" => "Nancy"})

      assert {:ok, %{data: data}} =
               Absinthe.run(@resolver_hits_doc, Schema, variables: %{"key" => "user"})

      second_count = get_in(data, ["resolver_hits", "hits"])

      assert second_count == first_count + 1
    end

    test "Records itself" do
      assert {:ok, %{data: data}} =
               Absinthe.run(@resolver_hits_doc, Schema, variables: %{"key" => "resolver_hits"})

      first_count = get_in(data, ["resolver_hits", "hits"])

      assert {:ok, %{data: data}} =
               Absinthe.run(@resolver_hits_doc, Schema, variables: %{"key" => "resolver_hits"})

      second_count = get_in(data, ["resolver_hits", "hits"])

      assert {:ok, %{data: data}} =
               Absinthe.run(@resolver_hits_doc, Schema, variables: %{"key" => "resolver_hits"})

      third_count = get_in(data, ["resolver_hits", "hits"])

      assert second_count == first_count + 1
      assert third_count == second_count + 1
    end
  end
end
