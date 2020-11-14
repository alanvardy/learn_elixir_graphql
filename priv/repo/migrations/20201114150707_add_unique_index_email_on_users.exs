defmodule LearnElixirGraphql.Repo.Migrations.AddUniqueIndexEmailOnUsers do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:email], name: "users_email_unique_index")
  end
end
