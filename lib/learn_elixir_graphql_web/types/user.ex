defmodule LearnElixirGraphqlWeb.Types.User do
  @moduledoc "User types for Absinthe"
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "A real human"
  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :auth_token, non_null(:string)

    field :preference, :preference, resolve: dataloader(LearnElixirGraphql.Accounts, :preference)
  end
end
