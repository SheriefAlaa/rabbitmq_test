defmodule PublisherConsumer.Config do
  def connection(), do: key(:connection)
  def email_exchange(), do: key(:email_exchange)
  def user_exchange(), do: key(:user_exchange)
  def email_queue(), do: key(:email_queue)
  def user_code_to_points_queue(), do: key(:user_code_to_points_queue)
  def user_points_to_rewards_queue(), do: key(:user_points_to_rewards_queue)
  def publish_options(), do: key(:publish_options)
  def consumer_module(), do: key(:consumer_module)
  def email_producer_module(), do: key(:email_producer_module)
  def user_producer_module(), do: key(:user_producer_module)

  defp key(key) do
    Application.fetch_env!(:publisher_consumer, :rabbitmq)[key]
  end
end
