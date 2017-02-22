# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :panacea, Panacea.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9Ek0X2EAZ0s3/3EVCraYW3qbdeMEpVgbzypFAV5Xy3Wgw9RknpVdqZgO7acg6PAL",
  render_errors: [view: Panacea.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Panacea.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :panacea, :asclepius,
  host: "asclepius",
  port: 5000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
