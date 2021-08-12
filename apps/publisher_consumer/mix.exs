defmodule PublisherConsumer.MixProject do
  use Mix.Project

  def project do
    [
      app: :publisher_consumer,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:lager, :logger, :amqp],
      mod: {PublisherConsumer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:common, in_umbrella: true},
      {:httpoison, "~> 1.8"},
      {:broadway, "~> 0.6.2"},
      {:broadway_rabbitmq, "~> 0.6.5"},
      {:gen_rmq, "~> 3.0.0"}
    ]
  end
end
