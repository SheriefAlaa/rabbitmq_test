defmodule PublisherConsumer.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      if(Mix.env() in [:prod, :dev]) do
        [
          PublisherConsumer.Email.Consumer,
          %{
            id: PublisherConsumer.Email.Publisher,
            start: {PublisherConsumer.Email.Publisher, :start_link, []}
          },
          PublisherConsumer.User.CodeToPointsConsumer,
          %{
            id: PublisherConsumer.API.User.Publisher,
            start: {PublisherConsumer.API.User.Publisher, :start_link, []}
          }
        ]
      else
        []
      end

    opts = [strategy: :one_for_one, name: PublisherConsumer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
