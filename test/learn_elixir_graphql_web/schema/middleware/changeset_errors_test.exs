defmodule LearnElixirGraphqlWeb.Schema.Middleware.ChangesetErrorsTest do
  use LearnElixirGraphql.DataCase, async: true
  alias LearnElixirGraphql.Accounts

  @create_user_doc """
    mutation createUser($name: String, $email: String, $token: String) {
      create_user(name: $name, email: $email, token: $token) {
        name
        email
      }
    }
  """

  describe "@create_user" do
    test "can handle changeset errors" do
      {:ok, users} = Accounts.all_users(%{})
      assert Enum.empty?(users)

      assert [%{message: "email: can't be blank", path: ["create_user"]}] =
               schema_errors(@create_user_doc, %{"name" => "Bobby", "token" => "faketoken"})
    end
  end
end
