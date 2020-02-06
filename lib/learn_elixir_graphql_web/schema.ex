defmodule LearnElixirGraphqlWeb.Schema do
  use Absinthe.Schema

  import_types(LearnElixirGraphqlWeb.Types.User)
  import_types(LearnElixirGraphqlWeb.Queries.User)
  import_types(LearnElixirGraphqlWeb.Mutations.User)

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end

  subscription do
    field :updated_user_preferences, :preferences do
      arg :user_id, :id
      config fn args, _ -> {:ok, topic: "users:#{args.user_id}"} end

      trigger :update_user_preferences, topic: fn preference -> "users:#{preference.user_id}" end

      resolve fn preferences, _, _ -> {:ok, preferences} end
    end
  end
end
