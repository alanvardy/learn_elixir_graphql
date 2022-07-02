defmodule LearnElixirGraphqlWeb.Middleware.Errors do
  @moduledoc "Converts Changeset and ErrorMessage errors into Absinthe errors"
  alias LearnElixirGraphql.ErrorUtils

  @behaviour Absinthe.Middleware
  @spec call(Absinthe.Resolution.t(), any) :: Absinthe.Resolution.t()
  def call(resolution, _) do
    %{resolution | errors: Enum.flat_map(resolution.errors, &handle_error/1)}
  end

  defp handle_error(%Ecto.Changeset{data: data} = changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {err, _opts} -> err end)
    |> Enum.map(&error_to_string(&1, data))
  end

  defp handle_error(%ErrorMessage{} = error), do: [Map.from_struct(error)]

  defp handle_error(error), do: [error]

  defp error_to_string({key, ["has already been taken"]}, data) do
    {:error, errors} = ErrorUtils.conflict(key, data)
    errors
  end

  defp error_to_string({key, value}, _data) do
    "#{key}: #{value}"
  end
end
