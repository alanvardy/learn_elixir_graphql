defmodule LearnElixirGraphqlWeb.Schema.Subscriptions.PreferenceTest do
  use LearnElixirGraphqlWeb.SubscriptionCase

  alias LearnElixirGraphql.Accounts

  @updated_user_preferences_sub_doc """
  subscription updatedUserPreferences($user_id: ID) {
    updated_user_preferences(user_id: $user_id) {
      user_id
      likes_emails
      likes_phone_calls
    }
  }
  """

  @update_user_preferences_doc """
    mutation updateUserPreferences($user_id: ID!, $likes_emails: Boolean, $likes_phone_calls: Boolean, $token: String!) {
      update_user_preferences(user_id: $user_id, likes_emails: $likes_emails, likes_phone_calls: $likes_phone_calls, token: $token) {
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

  describe "@updated_user_preferences" do
    test "sends the updated preferences when update_user_preferences mutation is triggered", %{
      socket: socket
    } do
      {:ok, user} = Accounts.create_user(@user_params)
      # Subscribe to the topic
      ref = push_doc(socket, @updated_user_preferences_sub_doc, variables: %{user_id: user.id})
      assert_reply(ref, :ok, %{subscriptionId: subscription_id})

      # update the user preferences
      ref =
        push_doc(socket, @update_user_preferences_doc,
          variables: %{"user_id" => user.id, "likes_emails" => false, "token" => "faketoken"}
        )

      # Assert user update response
      assert_reply(ref, :ok, reply)

      user_id = user.id

      assert %{
               data: %{
                 "update_user_preferences" => %{
                   "user_id" => ^user_id,
                   "likes_emails" => false,
                   "likes_phone_calls" => true
                 }
               }
             } = reply

      # Assert that the subscription was triggered with the same subscription id as before
      assert_push "subscription:data", data

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "updated_user_preferences" => %{
                     "user_id" => ^user_id,
                     "likes_emails" => false,
                     "likes_phone_calls" => true
                   }
                 }
               }
             } = data
    end
  end
end
