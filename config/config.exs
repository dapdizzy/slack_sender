# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :slack_sender,
  ecto_repos: [SlackSender.Repo]

# Configures the endpoint
config :slack_sender, SlackSenderWeb.Endpoint,
  url: [host: "localhost"],
  # url: [scheme: "http", host: "axstage01.mediasaturnrussia.ru", port: 17_000],
  secret_key_base: "ufL93dTpTQxCpoydqAXb7+owS26A2phBxZX/eA6+CvujAFMwDuawgFZbur9hj8lU",
  render_errors: [view: SlackSenderWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SlackSender.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :rabbitmq_sender,
  rabbit_options:
  [
    host: "localhost",
    username: "hunky",
    virtual_host: "/",
    password: "hunky"
  ],
  working_queue: "bot_queue"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
