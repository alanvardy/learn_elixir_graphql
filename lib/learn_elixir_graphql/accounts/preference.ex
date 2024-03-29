defmodule LearnElixirGraphql.Accounts.Preference do
  @moduledoc "User preferences"
  use Ecto.Schema
  import Ecto.Changeset
  alias LearnElixirGraphql.Accounts.User

  @type t :: %__MODULE__{
          id: pos_integer | nil,
          likes_emails: boolean | nil,
          likes_phone_calls: boolean | nil,
          user: User.t() | Ecto.Association.NotLoaded.t() | nil,
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  schema "preferences" do
    field :likes_emails, :boolean, default: false
    field :likes_phone_calls, :boolean, default: false
    belongs_to :user, User

    timestamps(type: :utc_datetime_usec)
  end

  @cast [:likes_emails, :likes_phone_calls]

  @doc false
  @spec create_changeset(map) :: Ecto.Changeset.t()
  @spec create_changeset(t, map) :: Ecto.Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast)
    |> validate_required(@cast)
  end

  # This one is needed for cast assoc in Users
  def create_changeset(preference, attrs) do
    preference
    |> cast(attrs, @cast)
    |> validate_required(@cast)
  end

  @doc false
  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(preference, attrs) do
    preference
    |> cast(attrs, @cast)
    |> validate_required(@cast)
  end
end
