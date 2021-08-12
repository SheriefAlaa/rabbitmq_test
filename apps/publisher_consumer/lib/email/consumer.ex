defmodule PublisherConsumer.Email.Consumer do
  @moduledoc """
  Documentation for `PublisherConsumer`.
  """
  use Broadway

  alias Broadway.Message
  alias Common.Email
  alias PublisherConsumer.Config

  @processor_concurrency 25

  defp producer_module() do
    case Config.email_consumer_module() do
      BroadwayRabbitMQ.Producer ->
        {
          BroadwayRabbitMQ.Producer,
          on_failure: :reject,
          queue: Config.email_queue(),
          qos: [
            prefetch_count: @processor_concurrency
          ],
          connection: Config.connection()
        }

      other_module ->
        {other_module, []}
    end
  end

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: producer_module(),
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: @processor_concurrency,
          # See: https://dockyard.com/blog/2021/06/24/tuning-broadway-rabbitmq-pipelines-for-latency
          max_demand: 1
        ]
      ]
    )
  end

  @impl true
  def handle_message(_processor, %Message{data: data} = message, _context) do
    decoded_data = Jason.decode!(data)
    :ok = Email.deliver_email(decoded_data)
    message
  end
end
