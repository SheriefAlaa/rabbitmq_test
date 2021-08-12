use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

for application <- [:common] do
  config application, Qiibee.Repo,
    url: System.fetch_env!("DATABASE_URL"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || 20)
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
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :api, ApiWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base
end
