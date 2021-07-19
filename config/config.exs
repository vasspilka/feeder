# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :feeder,
  ecto_repos: [Feeder.Repo]

# Configures the endpoint
config :feeder, FeederWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gw8djbaBErmUabqehZ0LYJ4ROQginpYtPtAd8d90mQ4U0GJzgCO2ed4Hhg0+KcnY",
  render_errors: [view: FeederWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Feeder.PubSub,
  live_view: [signing_salt: "IAyTvK9u"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.15",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
