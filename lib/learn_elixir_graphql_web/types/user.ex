defmodule LearnElixirGraphqlWeb.Types.User do
  use Absinthe.Schema.Notation

  @desc "User preferences (queries)"
  object :preferences do
    field(:user_id, :integer)
    field(:likes_emails, :boolean)
    field(:likes_phone_calls, :boolean)
  end

  @desc "User preferences (mutation)"
  input_object :input_preferences do
    field(:likes_emails, :boolean)
    field(:likes_phone_calls, :boolean)
  end

  @desc "A real human"
  object :user do
    field(:id, :id)
    field(:name, :string)
    field(:email, :string)
    field(:preferences, :preferences)
  end
end
