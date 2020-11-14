defmodule LearnElixirGraphqlWeb.Schema.Mutations.UserTest do
  use LearnElixirGraphql.DataCase, async: true
  alias LearnElixirGraphql.Accounts

  @user_params %{
    "name" => "Duffy",
    "email" => "duffy@email.com",
    "preference" => %{"likes_emails" => true, "likes_phone_calls" => true}
  }

  @create_user_doc """
    mutation createUser($name: String, $email: String) {
      create_user(name: $name, email: $email) {
        name
        email
      }
    }
  """

  describe "@create_user" do
    test "creates a user" do
      {:ok, users} = Accounts.all_users(%{})
      assert Enum.empty?(users)

      schema_success(@create_user_doc, %{"name" => "Bobby", "email" => "bobby@email.com"})

      {:ok, users} = Accounts.all_users(%{})
      assert Enum.count(users) == 1
      assert List.first(users).name == "Bobby"
    end

    test "can handle changeset errors" do
      {:ok, users} = Accounts.all_users(%{})
      assert Enum.empty?(users)

      assert [
               %{
                 locations: [%{column: 0, line: 2}],
                 message: "email: can't be blank",
                 path: ["create_user"]
               }
             ] = schema_errors(@create_user_doc, %{"name" => "Bobby"})
    end
  end

  @update_user_doc """
    mutation updateUser($id: Int, $name: String, $email: String) {
      update_user(id: $id, name: $name, email: $email) {
        id
        name
        email
      }
    }
  """

  describe "@update_user" do
    setup do
      %{user: create_user(@user_params)}
    end

    test "updates a user", %{user: user} do
      schema_success(@update_user_doc, %{
        "id" => user.id,
        "name" => "Buffy",
        "email" => "buffy@email.com"
      })

      {:ok, user} = Accounts.find_user(%{"id" => to_string(user.id)})
      assert user.name == "Buffy"
    end
  end

  @update_user_preferences_doc """
  mutation updateUser($user_id: Int, $likes_emails: Boolean, $likes_phone_calls: Boolean) {
    update_user_preferences(user_id: $user_id, likes_emails: $likes_emails, likes_phone_calls: $likes_phone_calls) {
      user_id
      likes_emails
      likes_phone_calls
    }
  }
  """

  describe "@update_user_preferences" do
    setup do
      %{user: create_user(@user_params)}
    end

    test "updates a user preference based on the user_id", %{user: user} do
      {:ok, preference} = Accounts.find_preference(%{"user_id" => to_string(user.id)})
      assert preference.likes_emails == true
      assert preference.likes_phone_calls == true

      schema_success(@update_user_preferences_doc, %{
        "user_id" => user.id,
        "likes_emails" => false,
        "likes_phone_calls" => false
      })

      {:ok, preference} = Accounts.find_preference(%{"user_id" => to_string(user.id)})
      assert preference.likes_emails == false
      assert preference.likes_phone_calls == false
    end
  end
end
