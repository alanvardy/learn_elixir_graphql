defmodule LearnElixirGraphqlWeb.SubscriptionCase do
  @moduledoc "Test case for GraphQL subscriptions"
  alias Absinthe.Phoenix.SubscriptionTest

  use ExUnit.CaseTemplate

  using do
    quote do
      use LearnElixirGraphqlWeb.ChannelCase
      use SubscriptionTest, schema: LearnElixirGraphqlWeb.Schema

      setup do
        {:ok, socket} = Phoenix.ChannelTest.connect(LearnElixirGraphqlWeb.UserSocket, %{})
        {:ok, socket} = SubscriptionTest.join_absinthe(socket)

        {:ok, %{socket: socket}}
      end
    end
  end
end
