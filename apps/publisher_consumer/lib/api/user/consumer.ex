defmodule PublisherConsumer.User.CodeToPointsConsumer do
  @moduledoc """
  Documentation for `PublisherConsumer`.
  """
  use Broadway

  require Logger

  alias Broadway.Message
  alias BlockchainSqlMock
  alias PublisherConsumer.Config

  @processor_concurrency 25

  defp producer_module() do
    case Config.consumer_module() do
      BroadwayRabbitMQ.Producer ->
        {
          BroadwayRabbitMQ.Producer,
          on_success: :ack,
          on_failure: :reject_and_requeue_once,
          queue: Config.user_code_to_points_queue(),
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
          max_demand: 1
        ]
      ]
    )
  end

  @impl true
  def handle_message(_processor, %Message{data: data} = message, _context) do
    decoded_data = Jason.decode!(data)

    case BlockchainSqlMock.code_to_points(decoded_data["code_id"], decoded_data["user_id"]) do
      {:ok, balance} ->
        Logger.info("CodeToPointsConsumer: Created balance: #{inspect(balance)}")

        message

      {:error, %Ecto.Changeset{} = changeset} ->
        Broadway.Message.failed(message, translate_errors(changeset))

      {:error, _} ->
        Broadway.Message.failed(message, "Code not found or expired")
    end
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Jason.encode!()
  end
end
