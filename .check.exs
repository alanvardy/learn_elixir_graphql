[
  retry: false,
  tools: [
    {:formatter, command: "mix format"},
    {:credo, command: "mix credo --strict"},
    {:ex_unit, command: "mix test"}
  ]
]
