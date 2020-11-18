defmodule LearnElixirGraphql.ErrorUtils do
  @moduledoc "Utilities for returning consistent errors"

  @type code :: :internal_server_error

  @spec internal_server_error_found(struct, map) :: {:error, %{message: code, details: map}}
  def internal_server_error_found(error_struct, params) do
    {:error,
     %{message: :internal_server_error, details: %{error_struct: error_struct, params: params}}}
  end
end
