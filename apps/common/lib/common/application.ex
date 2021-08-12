defmodule Common.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Qiibee.Repo
    ]

    opts = [strategy: :one_for_one, name: Common.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
