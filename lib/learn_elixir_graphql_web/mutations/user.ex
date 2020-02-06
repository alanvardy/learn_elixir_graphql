defmodule LearnElixirGraphqlWeb.Mutations.User do
  use Absinthe.Schema.Notation
  alias LearnElixirGraphqlWeb.Resolvers

  object :user_mutations do
    field :create_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string
      arg :preferences, :input_preferences

      resolve &Resolvers.User.create/2
    end

    field :update_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string
      arg :preferences, :input_preferences

      resolve &Resolvers.User.update/2
    end

    field :update_user_preferences, :preferences do
      arg :user_id, non_null(:id)
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean

      resolve &Resolvers.User.update_preferences/2
    end
  end
end
