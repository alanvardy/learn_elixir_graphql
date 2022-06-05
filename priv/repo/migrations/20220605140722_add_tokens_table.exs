defmodule LearnElixirGraphql.Repo.Migrations.AddTokensTable do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :token, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:tokens, [:updated_at])
  end
end
