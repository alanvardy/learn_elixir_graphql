defmodule LearnElixirGraphqlWeb.Schema.Queries.UserTest do
  use LearnElixirGraphql.DataCase, async: true

  import LearnElixirGraphql.Support.TestSetup

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

  describe "@user" do
    setup :users

    test "Can get the user by name", %{users: users} do
      user = Enum.find(users, fn user -> user.name == "Daisy" end)

      user_id =
        @user_doc
        |> Helpers.schema_success(%{"name" => "Daisy"})
        |> get_in(["user", "id"])
        |> String.to_integer()

      assert user_id === user.id
    end

    test "Returns an error if cannot find user" do
      assert [
               %{
                 code: :not_found,
                 details: %{params: %{name: "Donkey"}},
                 message: "no records found",
                 path: ["user"]
               }
             ] = Helpers.schema_errors(@user_doc, %{"name" => "Donkey"})
    end
  end

  @users_doc """
    query user_queries($name: String, $first: Int) {
      users(name: $name, first: $first) {
        id,
        name,
        email
      }
    }
  """

  describe "@users" do
    setup :users

    test "Can get all the users", %{users: users} do
      queried_users =
        @users_doc
        |> Helpers.schema_success(%{})
        |> Map.get("users")

      assert Enum.count(queried_users) == 3

      user_ids = Enum.map(queried_users, fn user -> String.to_integer(user["id"]) end)

      assert user_ids === Enum.map(users, fn user -> user.id end)
    end

    test "Can get the first 2 users", %{users: users} do
      queried_user_ids =
        @users_doc
        |> Helpers.schema_success(%{"first" => 2})
        |> Map.get("users")
        |> Enum.map(fn user -> String.to_integer(user["id"]) end)

      user_ids = users |> Enum.take(2) |> Enum.map(fn user -> user.id end)
      assert user_ids === queried_user_ids
    end

    test "Can get a user by name", %{users: users} do
      queried_user_ids =
        @users_doc
        |> Helpers.schema_success(%{"name" => "Duke"})
        |> Map.get("users")
        |> Enum.map(fn user -> String.to_integer(user["id"]) end)

      user_id = users |> Enum.find(fn user -> user.name == "Duke" end) |> Map.get(:id)
      assert [user_id] === queried_user_ids
    end
  end
end
