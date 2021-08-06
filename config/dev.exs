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

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
# config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
# config :phoenix, :plug_init_mode, :runtime
