use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :panacea, Panacea.Endpoint,
  http: [port: 4001],
  server: false

config :junit_formatter,
  report_dir: "/test-reports"

# Print only warnings and errors during test
config :logger, level: :warn
