defmodule LearnElixirGraphql.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :text, null: false
      add :email, :text, null: false

      timestamps(type: :utc_datetime_usec)
    end
  end
end
