defmodule LearnElixirGraphqlWeb.Schema.Queries.PreferenceTest do
  use LearnElixirGraphql.DataCase, async: true
  alias LearnElixirGraphql.Accounts
  alias LearnElixirGraphqlWeb.Schema

  @preference_doc """
    query findPreference($user_id: Int) {
      preference(user_id: $user_id) {
        user_id,
        likes_emails,
        likes_phone_calls
      }
    }
  """

  @user_params %{
    name: "Bob",
    email: "bobthebuilder@gmail.com",
    preference: %{
      likes_emails: true,
      likes_phone_calls: false
    }
  }

  describe "@preference" do
    test "Can get the preference by user_id" do
      assert {:ok, user} = Accounts.create_user(@user_params)

      assert {:ok, %{data: data}} =
               Absinthe.run(@preference_doc, Schema, variables: %{"user_id" => user.id})

      preference = data["preference"]
      assert preference["user_id"] === user.id
      assert preference["likes_emails"] === user.preference.likes_emails
      assert preference["likes_phone_calls"] === user.preference.likes_phone_calls
    end
  end

  @users_params [
    %{
      name: "Duke",
      email: "duke@email.com",
      preference: %{likes_emails: true, likes_phone_calls: false}
    },
    %{
      name: "Daisy",
      email: "daisy@email.com",
      preference: %{likes_emails: false, likes_phone_calls: true}
    },
    %{
      name: "Dingo",
      email: "dingo@email.com",
      preference: %{likes_emails: false, likes_phone_calls: false}
    }
  ]

  @preferences_doc """
    query allPreferences($likes_emails: Boolean, $likes_phone_calls: Boolean) {
      preferences(likes_emails: $likes_emails, likes_phone_calls: $likes_phone_calls) {
        likes_emails,
        likes_phone_calls
      }
    }
  """

  @preferences_with_users_doc """
    query allPreferences($likes_emails: Boolean, $likes_phone_calls: Boolean) {
      preferences(likes_emails: $likes_emails, likes_phone_calls: $likes_phone_calls) {
        likes_emails,
        likes_phone_calls
        user {
          name
          email
        }
      }
    }
  """

  describe "@preferences" do
    setup do
      users =
        for user_params <- @users_params do
          {:ok, user} = Accounts.create_user(user_params)
          user
        end

      %{users: users}
    end

    test "Can get all the preferences" do
      assert {:ok, %{data: data}} = Absinthe.run(@preferences_doc, Schema, variables: %{})

      assert data === %{
               "preferences" => [
                 %{"likes_emails" => true, "likes_phone_calls" => false},
                 %{"likes_emails" => false, "likes_phone_calls" => true},
                 %{"likes_emails" => false, "likes_phone_calls" => false}
               ]
             }
    end

    test "Can find the dog" do
      assert {:ok, %{data: data}} =
               Absinthe.run(@preferences_with_users_doc, Schema,
                 variables: %{"likes_emails" => false, "likes_phone_calls" => false}
               )

      assert data === %{
               "preferences" => [
                 %{
                   "likes_emails" => false,
                   "likes_phone_calls" => false,
                   "user" => %{"name" => "Dingo", "email" => "dingo@email.com"}
                 }
               ]
             }
    end
  end
end
