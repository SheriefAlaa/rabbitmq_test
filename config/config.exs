import Mix.Config

for application <- [:common, :blockchain] do
  config application, ecto_repos: [Qiibee.Repo]
end

# Swapable with a real Blockchain given that Blockchain behaviour/contract is respected.
config :blockchain, blockchain_module: BlockchainSqlMock

config :common,
  namespace: Common,
  generators: [binary_id: true, migration: true]

config :api, ApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8FbcixauRLj1PFJ/YXygf0Ww2OlphdnL4rsy/e+wloecSKUi2E+MDrQht9vFi9HZ",
  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Api.PubSub,
  live_view: [signing_salt: "zeo1Z0qJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

import_config "../apps/*/config/config.exs"

import_config "#{Mix.env()}.exs"
