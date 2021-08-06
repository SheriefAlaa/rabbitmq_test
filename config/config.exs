import Mix.Config

for application <- [:common] do
  config application, ecto_repos: [Qiibee.Repo], database: "foo"
end

config :common,
  namespace: Common,
  generators: [binary_id: true, migration: true]

# config :phoenix, :json_library, Jason

import_config "../apps/*/config/config.exs"

import_config "#{Mix.env()}.exs"
