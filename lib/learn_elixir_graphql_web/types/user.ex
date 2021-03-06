defmodule LearnElixirGraphqlWeb.Types.User do
  @moduledoc "User types for Absinthe"
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "A real human"
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string

    field :preference, :preference, resolve: dataloader(LearnElixirGraphql.Accounts, :preference)
  end
end
