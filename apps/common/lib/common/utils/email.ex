defmodule Common.Email do
  @behaviour Common.EmailService

  require Logger

  @impl true
  def deliver_email(map) do
    Logger.info("Delivering email: #{inspect(map)}")
  end
end
