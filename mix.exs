defmodule LearnElixirGraphql.MixProject do
  use Mix.Project

  def project do
    [
      app: :learn_elixir_graphql,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [
        test: :test,
        check: :test,
        credo: :test,
        dialyzer: :test,
        doctor: :test
      ],
      dialyzer: dialyzer(),
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {LearnElixirGraphql.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp dialyzer do
    [
      plt_ignore_apps: [:ecto_shorts],
      ignore_warnings: ".dialyzer-ignore.exs",
      list_unused_filters: true,
      flags: [:extra_return, :missing_return],
      plt_add_apps: [:ex_unit, :mix, :credo],
      plt_local_path: "dialyzer",
      plt_core_path: "dialyzer"
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6"},
      {:phoenix_pubsub, "~> 2.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:absinthe, "~> 1.7"},
      {:absinthe_plug, "~> 1.5"},
      {:absinthe_phoenix, "~> 2.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, "~> 0.15"},
      {:dataloader, "~> 1.0"},
      {:ecto_shorts, "~> 2.1.1"},
      {:ex_check, ">= 0.0.0", only: :test, runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:blitz_credo_checks, "~> 0.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: :test, runtime: false},
      {:doctor, "~> 0.18.0", only: :test},
      {:gen_stage, "~> 1.0"},
      {:libcluster, "~> 3.3"}
    ]
  end

  defp aliases do
    [
      "ecto.seed": ["run priv/repo/seeds.exs"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
