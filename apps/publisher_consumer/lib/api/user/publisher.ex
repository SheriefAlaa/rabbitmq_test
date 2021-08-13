defmodule PublisherConsumer.API.User.Publisher do
  @behaviour GenRMQ.Publisher

  alias PublisherConsumer.Config

  def init do
    init_rabbit()

    [
      connection: Config.connection(),
      exchange: Config.user_exchange()
    ]
  end

  def start_link do
    GenRMQ.Publisher.start_link(__MODULE__, name: __MODULE__)
  end

  def user_queue_current_size do
    GenRMQ.Publisher.message_count(__MODULE__, Config.user_code_to_points_queue())
  end

  @doc """
  Send an publish_code_to_points message to RMQ
  """
  @spec publish_code_to_points(%{
          user_id: String.t(),
          code_id: String.t()
        }) ::
          :ok | {:error, :blocked | :closing | :confirmation_timeout} | {:ok, :confirmed}
  def publish_code_to_points(code_to_points_request) do
    GenRMQ.Publisher.publish(
      __MODULE__,
      Jason.encode!(code_to_points_request),
      Config.user_code_to_points_queue(),
      Config.publish_options() ++ [routing_key: Config.user_code_to_points_queue()]
    )
  end

  @doc """
  Send an points_to_rewards message to RMQ
  """
  @spec publish_code_to_points(%{
          user_id: String.t(),
          reward_id: String.t()
        }) ::
          :ok | {:error, :blocked | :closing | :confirmation_timeout} | {:ok, :confirmed}
  def publish_points_to_rewards(points_to_rewards_request) do
    GenRMQ.Publisher.publish(
      __MODULE__,
      Jason.encode!(points_to_rewards_request),
      Config.user_points_to_rewards_queue(),
      Config.publish_options() ++ [routing_key: Config.user_code_to_points_queue()]
    )
  end

  defp init_rabbit do
    # Setup RabbitMQ connection
    {:ok, connection} = AMQP.Connection.open(Config.connection())
    {:ok, channel} = AMQP.Channel.open(connection)

    # Create exchange
    AMQP.Exchange.declare(channel, Config.user_exchange(), :topic, durable: true)

    # Create queues
    AMQP.Queue.declare(channel, Config.user_code_to_points_queue(), durable: true)
    AMQP.Queue.declare(channel, Config.user_points_to_rewards_queue(), durable: true)

    AMQP.Queue.bind(channel, Config.user_code_to_points_queue(), Config.user_exchange(),
      routing_key: Config.user_code_to_points_queue()
    )

    AMQP.Queue.bind(channel, Config.user_points_to_rewards_queue(), Config.user_exchange(),
      routing_key: Config.user_points_to_rewards_queue()
    )

    AMQP.Channel.close(channel)
  end
end
