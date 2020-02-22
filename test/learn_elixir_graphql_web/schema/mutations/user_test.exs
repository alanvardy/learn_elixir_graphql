defmodule LearnElixirGraphqlWeb.Schema.Mutations.UserTest do
  use LearnElixirGraphql.DataCase
  alias LearnElixirGraphql.Accounts
  alias LearnElixirGraphqlWeb.Schema

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

      assert {:ok, %{data: data}} =
               Absinthe.run(@create_user_doc, Schema,
                 variables: %{"name" => "Bobby", "email" => "bobby@email.com"}
               )

      {:ok, users} = Accounts.all_users(%{})
      assert Enum.count(users) == 1
      assert List.first(users).name == "Bobby"
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
    test "updates a user" do
      {:ok, user} = Accounts.create_user(%{name: "Duffy", email: "duffy@email.com"})

      assert {:ok, %{data: data}} =
               Absinthe.run(@update_user_doc, Schema,
                 variables: %{"id" => user.id, "name" => "Buffy", "email" => "buffy@email.com"}
               )

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

  @user_params %{
    "name" => "Duffy",
    "email" => "duffy@email.com",
    "preference" => %{"likes_emails" => true, "likes_phone_calls" => true}
  }

  describe "@update_user_preferences" do
    test "updates a user preference based on the user_id" do
      {:ok, user} = Accounts.create_user(@user_params)
      {:ok, preference} = Accounts.find_preference(%{"user_id" => to_string(user.id)})
      assert preference.likes_emails == true
      assert preference.likes_phone_calls == true

      assert {:ok, %{data: data}} =
               Absinthe.run(@update_user_preferences_doc, Schema,
                 variables: %{
                   "user_id" => user.id,
                   "likes_emails" => false,
                   "likes_phone_calls" => false
                 }
               )

      {:ok, preference} = Accounts.find_preference(%{"user_id" => to_string(user.id)})
      assert preference.likes_emails == false
      assert preference.likes_phone_calls == false
    end
  end
end
