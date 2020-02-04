defmodule LearnElixirGraphqlWeb.UserChannel do
  use LearnElixirGraphqlWeb, :channel

  def join("users", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("create_user", %{"id" => id}, socket) do
    broadcast(socket, "create_user", %{"id" => id})

    {:noreply, socket}
  end

  def handle_in("update_user_preferences", %{"id" => id}, socket) do
    broadcast(socket, "update_user_preferences", %{"id" => id})

    {:noreply, socket}
  end
end
