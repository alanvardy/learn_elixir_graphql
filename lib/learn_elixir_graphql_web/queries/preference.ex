defmodule LearnElixirGraphqlWeb.Queries.Preference do
  @moduledoc "Absinthe queries for user preferences"
  use Absinthe.Schema.Notation
  alias LearnElixirGraphqlWeb.Resolvers

  object :preference_queries do
    field :preferences, list_of(:preference) do
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      resolve &Resolvers.Preference.all/2
    end

    field :preference, :preference do
      arg :id, :id
      arg :user_id, :id
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      resolve &Resolvers.Preference.find/2
    end
  end
end
