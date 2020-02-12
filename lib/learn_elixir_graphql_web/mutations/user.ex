defmodule LearnElixirGraphqlWeb.Mutations.User do
  @moduledoc "User Mutations for Absinthe"
  use Absinthe.Schema.Notation
  alias LearnElixirGraphqlWeb.Resolvers

  object :user_mutations do
    field :create_user, :user do
      arg :name, :string
      arg :email, :string
      arg :preference, :preference_input

      resolve &Resolvers.User.create/2
    end

    field :update_user, :user do
      arg :id, :id
      arg :name, :string
      arg :email, :string

      resolve &Resolvers.User.update/2
    end

    field :update_user_preferences, :preference do
      arg :user_id, non_null(:id)
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean

      resolve &Resolvers.Preference.update/2
    end
  end
end
