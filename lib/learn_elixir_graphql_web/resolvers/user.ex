defmodule LearnElixirGraphqlWeb.Resolvers.User do
  use Absinthe.Schema.Notation
  alias LearnElixirGraphql.User

  def all(params, _) do
    User.all(params)
  end

  def find(%{id: id}, _) do
    User.find(id)
  end

  def create(params, _) do
    User.create(params)
  end

  def update(params, _) do
    User.update(params)
  end

  def update_preferences(params, _) do
    User.update_preferences(params)
  end
end
