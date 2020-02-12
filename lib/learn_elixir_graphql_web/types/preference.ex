defmodule LearnElixirGraphqlWeb.Types.Preference do
  @moduledoc "User types for Absinthe"
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "User preference (queries)"
  object :preference do
    field :id, :integer
    field :user_id, :integer
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :user, :user, resolve: dataloader(LearnElixirGraphql.Accounts, :user)
  end

  @desc "User preference (mutation)"
  input_object :preference_input do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
  end
end
