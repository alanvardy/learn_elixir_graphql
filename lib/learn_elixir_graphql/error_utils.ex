defmodule LearnElixirGraphql.ErrorUtils do
  @moduledoc "Utilities for returning consistent errors"
  require Logger

  @type code :: :internal_server_error | :not_found

  @spec internal_server_error_found(struct, map) :: {:error, %{message: String.t(), details: map}}
  def internal_server_error_found(error_struct, params) do
    message = "Internal server error"

    Task.start(fn -> raise error_struct end)

    Logger.error("""
    #{message}
    params: #{inspect(params)}
    error struct: #{inspect(error_struct)}
    """)

    {:error,
     %{
       message: "Internal server error",
       details: %{code: :internal_server_error, error_struct: error_struct, params: params}
     }}
  end

  @spec not_found(any, map) :: {:error, %{message: String.t(), details: map}}
  def not_found(resource, params) do
    message = "#{inspect(resource)} not found"
    Logger.info(message <> ", params: #{inspect(params)}")

    {:error,
     %{
       message: message,
       details: %{code: :not_found, params: params}
     }}
  end

  @spec not_acceptable(any, map) :: {:error, %{message: String.t(), details: map}}
  def not_acceptable(resource, params) do
    message = "Parameters not acceptable for #{inspect(resource)}"
    Logger.info(message <> ", params: #{inspect(params)}")

    {:error,
     %{
       message: message,
       details: %{code: :not_acceptable, params: params}
     }}
  end

  @spec conflict(atom, struct) :: {:error, %{message: String.t(), details: map}}
  def conflict(key, data) do
    message = "Conflict on #{inspect(data)}"

    Logger.info("""
    #{message}
    key: #{inspect(key)}
    """)

    {:error,
     %{
       message: message,
       details: %{code: :conflict, params: %{key: key}}
     }}
  end
end
