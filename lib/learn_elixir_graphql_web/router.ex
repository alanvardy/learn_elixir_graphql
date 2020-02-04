defmodule LearnElixirGraphqlWeb.Router do
  use LearnElixirGraphqlWeb, :router

  scope "/" do
    if Mix.env() === :dev do
      forward "/graphiql",
              Absinthe.Plug.GraphiQL,
              schema: LearnElixirGraphqlWeb.Schema,
              socket: LearnElixirGraphqlWeb.UserSocket,
              interface: :playground
    end

    forward "/api", Absinthe.Plug, schema: LearnElixirGraphqlWeb.Schema
  end
end
