defmodule LearnElixirGraphql.Config do
  @moduledoc """
  Application configuration
  """
  @app :learn_elixir_graphql

  @spec env :: :test | :dev | :prod
  def env do
    Application.fetch_env!(@app, :env)
  end

  @spec token_max_age :: pos_integer
  def token_max_age do
    Application.fetch_env!(@app, :token_max_age)
  end

  @spec pipeline_recheck_interval :: pos_integer
  def pipeline_recheck_interval do
    Application.fetch_env!(@app, :pipeline_recheck_interval)
  end
end
