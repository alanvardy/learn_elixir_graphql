defmodule LearnElixirGraphqlWeb.Types.Preference do
  @moduledoc "User types for Absinthe"
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "User preference (queries)"
  object :preference do
    field :id, non_null(:integer)
    field :user_id, non_null(:integer)
    field :likes_emails, non_null(:boolean)
    field :likes_phone_calls, non_null(:boolean)
    field :user, non_null(:user), resolve: dataloader(LearnElixirGraphql.Accounts, :user)
  end

  @desc "User preference (mutation)"
  input_object :preference_input do
    field :likes_emails, non_null(:boolean)
    field :likes_phone_calls, non_null(:boolean)
  end
end
