use Mix.Config

for application <- [:common] do
  config application, Qiibee.Repo,
    username: "root",
    password: "",
    database: "qiibee_dev",
    hostname: "localhost",
    show_sensitive_data_on_connection_error: true,
    pool_size: 20
end

# TODO: convert all to be env vars.
# Joint prod/dev env variables
config :publisher_consumer, :rabbitmq,
  connection: "amqp://guest:guest@rabbitmq",
  email_exchange: "qiibee_email_exchange",
  email_queue: "emails",
  publish_options: [persistent: true, content_type: "application/json"],
  email_producer_module: PublisherConsumer.Email.Publisher,
  email_consumer_module: BroadwayRabbitMQ.Producer

config :api, ApiWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
