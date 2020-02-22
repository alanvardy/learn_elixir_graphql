defmodule LearnElixirGraphqlWeb.Subscriptions.Preference do
  @moduledoc "User resolvers for Absinthe"
  use Absinthe.Schema.Notation

  object :preference_subscriptions do
    field :updated_user_preferences, :preference do
      arg :user_id, :id
      config fn args, _ -> {:ok, topic: "users:#{args.user_id}"} end

      trigger :update_user_preferences,
        topic: fn preference -> "users:#{preference.user_id}" end

      resolve fn preference, _, _ -> {:ok, preference} end
    end
  end
end
