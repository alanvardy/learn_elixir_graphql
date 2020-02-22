defmodule LearnElixirGraphqlWeb.Schema.Queries.UserTest do
  use LearnElixirGraphql.DataCase, async: true
  alias LearnElixirGraphql.Accounts
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

  @user_params %{
    name: "Nancy",
    email: "nancybell@email.com",
    age: 53
  }

  describe "@user" do
    test "Can get the user by name" do
      assert {:ok, user} = Accounts.create_user(@user_params)

      assert {:ok, %{data: data}} =
               Absinthe.run(@user_doc, Schema, variables: %{"name" => "Nancy"})

      user_id =
        data
        |> get_in(["user", "id"])
        |> String.to_integer()

      assert user_id === user.id
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

  @users_params [
    %{name: "Duke", email: "duke@email.com"},
    %{name: "Daisy", email: "daisy@email.com"},
    %{name: "Dingo", email: "dingo@email.com"}
  ]

  describe "@users" do
    setup do
      users =
        for user_params <- @users_params do
          {:ok, user} = Accounts.create_user(user_params)
          user
        end

      %{users: users}
    end

    test "Can get all the users", %{users: users} do
      assert {:ok, %{data: data}} = Absinthe.run(@users_doc, Schema, variables: %{})

      queried_users = Map.get(data, "users")
      assert Enum.count(queried_users) == 3

      user_ids = Enum.map(queried_users, fn user -> String.to_integer(user["id"]) end)

      assert user_ids === Enum.map(users, fn user -> user.id end)
    end

    test "Can get the first 2 users", %{users: users} do
      assert {:ok, %{data: data}} = Absinthe.run(@users_doc, Schema, variables: %{"first" => 2})

      queried_user_ids = Enum.map(data["users"], fn user -> String.to_integer(user["id"]) end)
      user_ids = users |> Enum.take(2) |> Enum.map(fn user -> user.id end)
      assert user_ids === queried_user_ids
    end

    test "Can get a user by name", %{users: users} do
      assert {:ok, %{data: data}} =
               Absinthe.run(@users_doc, Schema, variables: %{"name" => "Duke"})

      queried_user_ids = Enum.map(data["users"], fn user -> String.to_integer(user["id"]) end)
      user_id = users |> Enum.find(fn user -> user.name == "Duke" end) |> Map.get(:id)
      assert [user_id] === queried_user_ids
    end
  end
end
