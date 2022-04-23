defmodule LearnElixirGraphql.Repo.Migrations.ChangeUsersColumnsToText do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :name, :text, from: :string
      modify :email, :text, from: :string
    end
  end
end
