defmodule LearnElixirGraphqlWeb.Schema.Queries.PreferenceTest do
  use LearnElixirGraphql.DataCase, async: true

  import LearnElixirGraphql.Support.TestSetup

  alias LearnElixirGraphql.Support.Helpers

  @preference_doc """
    query findPreference($user_id: ID) {
      preference(user_id: $user_id) {
        user_id,
        likes_emails,
        likes_phone_calls
      }
    }
  """

  describe "@preference" do
    setup :users

    test "Can get the preference by user_id", %{users: users} do
      user = List.first(users)
      data = Helpers.schema_success(@preference_doc, %{"user_id" => user.id})
      Helpers.assert_comparable(user.preference, data["preference"])
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
    setup :users

    test "Can get all the preferences", %{users: users} do
      data = Helpers.schema_success(@preferences_doc, %{})
      result = %{"preferences" => Enum.map(users, fn user -> user.preference end)}
      Helpers.assert_comparable(data, result)
    end

    test "Can find the dog" do
      data =
        Helpers.schema_success(@preferences_with_users_doc, %{
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
