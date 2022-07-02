defmodule LearnElixirGraphql.Accounts.User do
  @moduledoc "User schema"
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias LearnElixirGraphql.Accounts.Preference

  @type t :: %__MODULE__{
          id: pos_integer | nil,
          email: String.t() | nil,
          name: String.t() | nil,
          preference: Preference.t() | Ecto.Association.NotLoaded.t() | nil,
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  schema "users" do
    field :email, :string
    field :name, :string
    has_one :preference, Preference

    timestamps(type: :utc_datetime_usec)
  end

  @cast [:name, :email]

  @doc false
  @spec create_changeset(map) :: Ecto.Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast)
    |> validate_required(@cast)
    |> validate_length(:name, max: 255)
    |> unique_constraint(:email,
      message: "has already been taken",
      name: "users_email_unique_index"
    )
    |> cast_assoc(:preference, with: &Preference.create_changeset/2)
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, @cast)
    |> validate_required(@cast)
  end

  @spec select_id(Ecto.Queryable.t()) :: Ecto.Query.t()
  def select_id(query \\ __MODULE__) do
    select(query, [u], u.id)
  end
end
