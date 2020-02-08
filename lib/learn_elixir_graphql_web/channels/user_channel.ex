defmodule LearnElixirGraphqlWeb.UserChannel do
  @moduledoc false
  use LearnElixirGraphqlWeb, :channel

  @spec join(binary, map, Phoenix.Socket.t()) :: {:ok, Phoenix.Socket.t()}
  def join("users", _payload, socket) do
    {:ok, socket}
  end
end
