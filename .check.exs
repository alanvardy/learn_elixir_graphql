[
  retry: false,
  tools: [
    {:formatter, command: "mix format"},
    {:credo, command: "mix credo --strict"},
    {:ex_unit, command: "mix test", env: %{"MIX_ENV" => "test"}}
  ]
]
