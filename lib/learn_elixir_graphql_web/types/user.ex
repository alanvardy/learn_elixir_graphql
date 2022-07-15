defmodule LearnElixirGraphqlWeb.Types.User do
  @moduledoc "User types for Absinthe"
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  alias LearnElixirGraphqlWeb.Resolvers

  @desc "A real human"
  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)

    field :auth_token, non_null(:string) do
      resolve &Resolvers.User.find_auth_token/3
    end

    field :preference, :preference do
      resolve dataloader(LearnElixirGraphql.Accounts, :preference)
    end
  end
end
