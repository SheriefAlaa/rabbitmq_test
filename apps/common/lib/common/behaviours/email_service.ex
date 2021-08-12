defmodule Common.EmailService do
  @moduledoc """
  Behavior for an email service
  """

  @callback deliver_email(%{email: String.t(), message: String.t()}) :: :ok | :error

  def email_service_module() do
    Application.fetch_env!(:email_service, :email_service_module)
  end

  def deliver_email(map) do
    email_service_module().deliver_email(map)
  end
end
