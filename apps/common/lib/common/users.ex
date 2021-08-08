defmodule Common.Users do
  @moduledoc """
  The Admins context.
  """

  import Ecto.Query, warn: false
  alias Qiibee.Repo

  alias Common.Users.User

  @doc """
  Returns a user with balance as struct attribute.

  balance is a virtual field that is filled by this function.

  """
  @spec user_with_balance(Ecto.UUID.t()) :: nil | %User{}
  def user_with_balance(id) do
    from(u in User, where: u.id == ^id)
    |> Repo.one()
  end
end
