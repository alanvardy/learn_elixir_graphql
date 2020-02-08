defmodule LearnElixirGraphql.Accounts.User do
  @moduledoc "User schema"
  use Ecto.Schema
  import Ecto.Changeset
  alias LearnElixirGraphql.Accounts.Preference

  @type t :: %__MODULE__{
          id: non_neg_integer | nil,
          email: binary | nil,
          name: binary | nil,
          preference: Preference.t() | nil
        }

  schema "users" do
    field :email, :string
    field :name, :string
    has_one :preference, Preference
  end

  @available_fields [:name, :email]

  @doc false
  @spec create_changeset(map) :: Ecto.Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
    |> cast_assoc(:preference, with: &Preference.create_changeset/2)
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
  end
end
