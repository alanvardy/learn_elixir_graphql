defmodule LearnElixirGraphqlWeb.Router do
  use LearnElixirGraphqlWeb, :router

  scope "/" do
    forward "/api", Absinthe.Plug, schema: LearnElixirGraphqlWeb.Schema

    if Mix.env() !== :prod do
      forward "/graphiql",
              Absinthe.Plug.GraphiQL,
              schema: LearnElixirGraphqlWeb.Schema,
              socket: LearnElixirGraphqlWeb.UserSocket,
              interface: :playground
    end
  end
end
