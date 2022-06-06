defmodule LearnElixirGraphql.Config do
  @moduledoc """
  Application configuration
  """
  @app :learn_elixir_graphql

  def env do
    Application.fetch_env!(@app, :env)
  end

  def token_max_age do
    Application.fetch_env!(@app, :token_max_age)
  end

  def pipeline_recheck_interval do
    Application.fetch_env!(@app, :pipeline_recheck_interval)
  end
end
