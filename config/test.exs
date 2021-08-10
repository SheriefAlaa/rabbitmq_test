use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

config :common, Qiibee.Repo,
  username: "root",
  password: "",
  database: "qiibee_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :api, ApiWeb.Endpoint,
  http: [port: 4002],
  server: false
