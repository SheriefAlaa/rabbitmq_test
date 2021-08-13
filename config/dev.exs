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

config :publisher_consumer, :rabbitmq,
  connection: "amqp://guest:guest@localhost:5672",
  email_exchange: "email_exchange",
  email_queue: "emails",
  user_exchange: "user_exchange",
  user_code_to_points_queue: "user_code_to_points",
  user_points_to_rewards_queue: "user_points_to_rewards",
  publish_options: [persistent: true, content_type: "application/json"],
  consumer_module: BroadwayRabbitMQ.Producer,
  email_producer_module: PublisherConsumer.Email.Publisher,
  user_producer_module: PublisherConsumer.API.User.Publisher

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
