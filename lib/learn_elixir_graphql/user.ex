defmodule LearnElixirGraphql.User do
  @users [
    %{
      id: 1,
      name: "Bill",
      email: "bill@gmail.com",
      preferences: %{
        likes_emails: false,
        likes_phone_calls: true
      }
    },
    %{
      id: 2,
      name: "Alice",
      email: "alice@gmail.com",
      preferences: %{
        likes_emails: true,
        likes_phone_calls: false
      }
    },
    %{
      id: 3,
      name: "Jill",
      email: "jill@hotmail.com",
      preferences: %{
        likes_emails: true,
        likes_phone_calls: true
      }
    },
    %{
      id: 4,
      name: "Tim",
      email: "tim@gmail.com",
      preferences: %{
        likes_emails: false,
        likes_phone_calls: false
      }
    }
  ]

  def all(params \\ []) do
    users = Enum.reduce(params, @users, &by_params/2)

    case users do
      [] ->
        {:error, %{message: "not found", details: params}}

      users ->
        {:ok, users}
    end
  end

  defp by_params({field, value}, users) do
    Enum.filter(users, fn user -> get_in(user, [:preferences, field]) === value end)
  end

  def find(id) do
    id = String.to_integer(id)

    case Enum.find(@users, fn user -> user[:id] === id end) do
      nil -> {:error, %{id: id}}
      user -> {:ok, user}
    end
  end

  def create(params) do
    {:ok, params}
  end

  def update(%{id: id} = params) do
    with {:ok, user} <- find(id) do
      {:ok, Map.merge(user, params)}
    end
  end

  def update_preferences(%{user_id: user_id} = params) do
    with {:ok, user} <- find(user_id) do
      preferences =
        user.preferences
        |> Map.merge(params)
        |> Map.put(:user_id, user.id)

      {:ok, preferences}
    end
  end

  defp has_preference?(method, user, value) do
    accessor =
      case method do
        :emails -> :likes_emails
        :calls -> :likes_phone_calls
      end

    get_in(user, [:preferences, accessor]) === value
  end
end
