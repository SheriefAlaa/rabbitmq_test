use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

for application <- [:common] do
  config application, Qiibee.Repo,
    url: System.fetch_env!("DATABASE_URL"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || 20)
end
