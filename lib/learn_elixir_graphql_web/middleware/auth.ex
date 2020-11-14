defmodule LearnElixirGraphqlWeb.Middleware.Auth do
  @behaviour Absinthe.Middleware

  @impl Absinthe.Middleware
  def call(%{arguments: %{token: token} = arguments} = resolution, _) do
    if token === Application.fetch_env!(:learn_elixir_graphql, :token) do
      %Absinthe.Resolution{resolution | arguments: Map.drop(arguments, [:token])}
    else
      Absinthe.Resolution.put_result(resolution, {:error, "invalid_token"})
    end
  end

  def call(resolution, _) do
    Absinthe.Resolution.put_result(resolution, {:error, "no token provided"})
  end
end
