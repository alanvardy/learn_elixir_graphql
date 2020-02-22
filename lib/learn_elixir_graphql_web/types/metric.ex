defmodule LearnElixirGraphqlWeb.Types.Metric do
  @moduledoc "Metric types for Absinthe"
  use Absinthe.Schema.Notation

  @desc "The number of times a resolver has his a particular key"
  object :resolver_hit do
    field :key, :string
    field :hits, :integer
  end
end
