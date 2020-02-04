defmodule LearnElixirGraphqlWeb.UserChannel do
  use LearnElixirGraphqlWeb, :channel

  def join("users", _payload, socket) do
    {:ok, socket}
  end
end
