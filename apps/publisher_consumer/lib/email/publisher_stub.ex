defmodule PublisherConsumer.Email.PublisherStub do
  @moduledoc """
  Mimc PublisherConsumer.Email.Publisher.

  For testing purposes only.
  """

  @doc """
  Send an email message to RMQ
  """
  @spec publish_email(%{
          email: String.t(),
          message: String.t()
        }) ::
          :ok
  def publish_email(_email_message) do
    :ok
  end
end
