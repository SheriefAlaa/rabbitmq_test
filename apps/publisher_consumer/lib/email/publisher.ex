defmodule PublisherConsumer.Email.Publisher do
  @behaviour GenRMQ.Publisher

  alias PublisherConsumer.Config

  def init do
    init_rabbit()

    [
      connection: Config.connection(),
      exchange: {:fanout, Config.email_exchange()}
    ]
  end

  def start_link do
    GenRMQ.Publisher.start_link(__MODULE__, name: __MODULE__)
  end

  @spec email_queue_current_size() :: Integer.t() | no_return()
  def email_queue_current_size do
    GenRMQ.Publisher.message_count(__MODULE__, Config.email_queue())
  end

  @doc """
  Send an email message to RMQ
  """
  @spec publish_email(%{
          email: String.t(),
          message: String.t()
        }) ::
          :ok | {:error, :blocked | :closing | :confirmation_timeout} | {:ok, :confirmed}
  def publish_email(email_message) do
    GenRMQ.Publisher.publish(
      __MODULE__,
      Jason.encode!(email_message),
      Config.email_queue(),
      Config.publish_options()
    )
  end

  defp init_rabbit do
    # Setup RabbitMQ connection
    {:ok, connection} = AMQP.Connection.open(Config.connection())
    {:ok, channel} = AMQP.Channel.open(connection)

    # Create exchange
    AMQP.Exchange.declare(channel, Config.email_exchange(), :fanout, durable: true)

    # Create queues
    AMQP.Queue.declare(channel, Config.email_queue(), durable: true)
    AMQP.Queue.bind(channel, Config.email_queue(), Config.email_exchange())
    AMQP.Channel.close(channel)
  end
end
