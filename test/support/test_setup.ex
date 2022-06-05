defmodule LearnElixirGraphql.Support.TestSetup do
  @moduledoc false

  alias LearnElixirGraphql.Accounts

  @user_params %{
    "name" => "Duffy",
    "email" => "duffy@email.com",
    "preference" => %{"likes_emails" => true, "likes_phone_calls" => true},
    "token" => %{"token" => "ABCD"}
  }

  @users_params [
    %{
      name: "Duke",
      email: "duke@email.com",
      preference: %{likes_emails: true, likes_phone_calls: false},
      token: %{token: "ABCD"}
    },
    %{
      name: "Daisy",
      email: "daisy@email.com",
      preference: %{likes_emails: false, likes_phone_calls: true},
      token: %{token: "ABCD"}
    },
    %{
      name: "Dingo",
      email: "dingo@email.com",
      preference: %{likes_emails: false, likes_phone_calls: false},
      token: %{token: "ABCD"}
    }
  ]

  def user(_) do
    {:ok, user} = Accounts.create_user(@user_params)
    %{user: user}
  end

  def users(_) do
    users =
      for user <- @users_params do
        {:ok, user} = Accounts.create_user(user)
        user
      end

    %{users: users}
  end
end
