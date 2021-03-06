defmodule LearnElixirGraphqlWeb.Schema.Mutations.UserTest do
  use LearnElixirGraphql.DataCase, async: true
  alias LearnElixirGraphql.Accounts

  @long_string 1..256
               |> Enum.map(&to_string/1)
               |> Enum.join()

  @user_params %{
    "name" => "Duffy",
    "email" => "duffy@email.com",
    "preference" => %{"likes_emails" => true, "likes_phone_calls" => true}
  }

  @create_user_doc """
    mutation createUser($name: String, $email: String, $token: String) {
      create_user(name: $name, email: $email, token: $token) {
        name
        email
      }
    }
  """

  describe "@create_user" do
    test "creates a user" do
      {:ok, users} = Accounts.all_users(%{})
      assert Enum.empty?(users)

      schema_success(@create_user_doc, %{
        "name" => "Bobby",
        "email" => "bobby@email.com",
        "token" => "faketoken"
      })

      {:ok, users} = Accounts.all_users(%{})
      assert Enum.count(users) == 1
      assert List.first(users).name == "Bobby"
    end

    test "cannot insert the same email address twice" do
      schema_success(@create_user_doc, %{
        "name" => "Bobby",
        "email" => "bobby@email.com",
        "token" => "faketoken"
      })

      {:ok, users} = Accounts.all_users(%{})
      assert Enum.count(users) == 1
      assert List.first(users).name == "Bobby"

      assert [
               %{
                 message:
                   "Conflict on %LearnElixirGraphql.Accounts.User{__meta__: #Ecto.Schema.Metadata<:built, \"users\">, email: nil, id: nil, name: nil, preference: #Ecto.Association.NotLoaded<association :preference is not loaded>}",
                 path: ["create_user"],
                 details: %{code: :conflict, params: %{key: :email}}
               }
             ] =
               schema_errors(@create_user_doc, %{
                 "name" => "Bobby",
                 "email" => "bobby@email.com",
                 "token" => "faketoken"
               })

      assert Enum.count(users) == 1
    end

    test "returns an internal server error" do
      assert [
               %{
                 details: %{
                   error_struct: %Postgrex.Error{
                     message: nil,
                     postgres: %{
                       code: :string_data_right_truncation,
                       file: "varchar.c",
                       message: "value too long for type character varying(255)",
                       pg_code: "22001",
                       routine: "varchar",
                       severity: "ERROR",
                       unknown: "ERROR"
                     },
                     query: nil
                   },
                   params: %{email: "bobby@email.com", name: _}
                 },
                 message: "Internal server error",
                 path: ["create_user"]
               }
             ] =
               schema_errors(@create_user_doc, %{
                 "name" => @long_string,
                 "email" => "bobby@email.com",
                 "token" => "faketoken"
               })
    end
  end

  @update_user_doc """
    mutation updateUser($id: Int, $name: String, $email: String, $token: String) {
      update_user(id: $id, name: $name, email: $email, token: $token) {
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
        "email" => "buffy@email.com",
        "token" => "faketoken"
      })

      {:ok, user} = Accounts.find_user(%{"id" => to_string(user.id)})
      assert user.name == "Buffy"
    end
  end

  @update_user_preferences_doc """
  mutation updateUser($user_id: Int, $likes_emails: Boolean, $likes_phone_calls: Boolean, $token: String) {
    update_user_preferences(user_id: $user_id, likes_emails: $likes_emails, likes_phone_calls: $likes_phone_calls, token: $token) {
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
        "likes_phone_calls" => false,
        "token" => "faketoken"
      })

      {:ok, preference} = Accounts.find_preference(%{"user_id" => to_string(user.id)})
      assert preference.likes_emails == false
      assert preference.likes_phone_calls == false
    end
  end
end
