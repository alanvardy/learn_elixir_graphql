defmodule LearnElixirGraphqlWeb.Schema.Queries.PreferenceTest do
  use LearnElixirGraphql.DataCase, async: true

  @preference_doc """
    query findPreference($user_id: ID) {
      preference(user_id: $user_id) {
        user_id,
        likes_emails,
        likes_phone_calls
      }
    }
  """

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

  describe "@preference" do
    setup do
      %{users: create_users(@users_params)}
    end

    test "Can get the preference by user_id", %{users: users} do
      user = List.first(users)
      data = schema_success(@preference_doc, %{"user_id" => user.id})
      assert_comparable(user.preference, data["preference"])
    end
  end

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
      %{users: create_users(@users_params)}
    end

    test "Can get all the preferences", %{users: users} do
      data = schema_success(@preferences_doc, %{})
      result = %{"preferences" => Enum.map(users, fn user -> user.preference end)}
      assert_comparable(data, result)
    end

    test "Can find the dog" do
      data =
        schema_success(@preferences_with_users_doc, %{
          "likes_emails" => false,
          "likes_phone_calls" => false
        })

      result = %{
        "preferences" => [
          %{
            "likes_emails" => false,
            "likes_phone_calls" => false,
            "user" => %{"name" => "Dingo", "email" => "dingo@email.com"}
          }
        ]
      }

      assert data === result
    end
  end
end
