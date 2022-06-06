defmodule LearnElixirGraphql.Accounts.Token do
  @moduledoc "User preferences"
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias LearnElixirGraphql.Accounts.User
  alias LearnElixirGraphql.Config

  @max_age Config.token_max_age()

  @timestamps_opts type: :utc_datetime_usec

  @type t :: %__MODULE__{
          id: pos_integer | nil,
          token: String.t() | nil,
          user: User.t() | Ecto.Association.NotLoaded.t() | nil,
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  schema "tokens" do
    field :token, :string
    belongs_to :user, User

    timestamps(type: :utc_datetime_usec)
  end

  @cast [:token]

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

  def limit(query \\ __MODULE__, limit) do
    limit(query, [t], ^limit)
  end

  def where_expired(query \\ __MODULE__) do
    max_age = DateTime.add(DateTime.utc_now(), -@max_age, :millisecond)

    where(query, [t], t.updated_at <= ^max_age)
  end
end
