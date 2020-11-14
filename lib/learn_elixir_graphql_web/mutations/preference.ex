defmodule LearnElixirGraphqlWeb.Mutations.Preference do
  @moduledoc "User Mutations for Absinthe"
  use Absinthe.Schema.Notation
  alias LearnElixirGraphqlWeb.Resolvers

  object :preference_mutations do
    field :update_preference, :preference do
      arg :id, :id
      arg :user_id, :integer
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      arg :token, non_null(:string), description: "Required for authentication"

      resolve &Resolvers.Preference.update/2
    end
  end
end
