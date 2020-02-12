defmodule LearnElixirGraphql.Accounts.User do
  @moduledoc "User schema"
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias EctoShorts.Actions
  alias LearnElixirGraphql.Accounts.Preference

  @type params :: keyword | map
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

  @spec all(params) :: {:ok, [t()]} | {:error, binary}
  def all(params) do
    # I wasnt able to make dialyzer accept the module as the first argument,
    # Actions.all(User, params) fails for me
    result = Actions.all(from(u in __MODULE__, preload: [:preference]), params)
    {:ok, result}
  end

  @spec find(params) :: {:error, binary} | {:ok, t()}
  def find(params) do
    from(u in __MODULE__) |> Actions.find(params)
  end

  @spec create(params) :: {:error, Ecto.Changeset.t()} | {:ok, t()}
  def create(params) do
    Actions.create(__MODULE__, params)
  end

  @spec update(%{id: binary}) :: {:error, Ecto.Changeset.t()} | {:ok, t()}
  def update(%{id: id} = params) do
    with {:ok, user} <- find(%{id: String.to_integer(id)}) do
      params = Map.delete(params, :id)
      Actions.update(__MODULE__, user, params)
    end
  end
end
