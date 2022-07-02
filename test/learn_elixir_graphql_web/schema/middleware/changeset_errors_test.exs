defmodule LearnElixirGraphqlWeb.Schema.Middleware.ChangesetErrorsTest do
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
    test "can handle changeset errors" do
      assert [] = Accounts.all_users(%{})

      assert [%{message: "email: can't be blank", path: ["create_user"]}] =
               Helpers.schema_errors(@create_user_doc, %{
                 "name" => "Bobby",
                 "token" => "faketoken"
               })
    end
  end
end
