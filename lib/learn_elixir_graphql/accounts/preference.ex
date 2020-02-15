defmodule LearnElixirGraphql.Accounts.Preference do
  @moduledoc "User preferences"
  use Ecto.Schema
  import Ecto.Changeset
  alias LearnElixirGraphql.Accounts.User

  @type t :: %__MODULE__{
          id: non_neg_integer | nil,
          likes_emails: boolean | nil,
          likes_phone_calls: boolean | nil,
          user: User.t() | nil
        }

  schema "preferences" do
    field :likes_emails, :boolean, default: false
    field :likes_phone_calls, :boolean, default: false
    belongs_to :user, User
  end

  @available_fields [:likes_emails, :likes_phone_calls]

  @doc false
  @spec create_changeset(map) :: Ecto.Changeset.t()
  @spec create_changeset(t, map) :: Ecto.Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
  end

  # This one is needed for cast assoc in Users
  def create_changeset(preference, attrs) do
    preference
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
  end

  @doc false
  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(preference, attrs) do
    preference
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
  end
end
