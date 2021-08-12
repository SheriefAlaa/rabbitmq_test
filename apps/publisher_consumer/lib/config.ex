defmodule PublisherConsumer.Config do
  def connection(), do: key(:connection)
  def email_exchange(), do: key(:email_exchange)
  def email_queue(), do: key(:email_queue)
  def publish_options(), do: key(:publish_options)

  def password(), do: key(:password)

  def username(), do: key(:username)

  def email_consumer_module() do
    key(:email_consumer_module)
  end

  def email_producer_module() do
    key(:email_producer_module)
  end

  defp key(key) do
    Application.fetch_env!(:publisher_consumer, :rabbitmq)[key]
  end
end
