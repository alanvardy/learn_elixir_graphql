defmodule LearnElixirGraphqlWeb.Queries.User do
  @moduledoc "Absinthe queries for users"
  use Absinthe.Schema.Notation
  alias LearnElixirGraphqlWeb.Resolvers

  object :user_queries do
    field :users, list_of(:user) do
      arg :name, :string
      arg :email, :string
      # Ecto Shorts
      arg :before, :integer
      arg :after, :integer
      arg :first, :integer
      resolve &Resolvers.User.all/2
    end

    field :user, :user do
      arg :id, :id
      arg :name, :string
      arg :email, :string
      resolve &Resolvers.User.find/2
    end
  end
end
