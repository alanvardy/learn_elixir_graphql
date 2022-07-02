defmodule LearnElixirGraphqlWeb.Schema.Middleware.AuthTest do
  use LearnElixirGraphql.DataCase, async: true
  alias LearnElixirGraphql.Accounts
  alias LearnElixirGraphql.Support.Helpers

  @create_user_doc """
    mutation createUser($name: String, $email: String, $token: String!) {
      create_user(name: $name, email: $email, token: $token) {
        name
        email
      }
    }
  """

  describe "@create_user" do
    test "Cannot create a user when no token is provided" do
      assert [] = Accounts.all_users(%{})

      [%{message: "In argument \"token\": Expected type \"String!\", found null."}, _] =
        Helpers.schema_errors(@create_user_doc, %{"name" => "Bobby", "email" => "bobby@email.com"})

      assert [] = Accounts.all_users(%{})
    end

    test "Cannot create a user when wrong token is provided" do
      assert [] = Accounts.all_users(%{})

      [%{message: "invalid_token", path: ["create_user"]}] =
        Helpers.schema_errors(@create_user_doc, %{
          "name" => "Bobby",
          "email" => "bobby@email.com",
          "token" => "totallynottherighttoken"
        })

      assert [] = Accounts.all_users(%{})
    end
  end
end
