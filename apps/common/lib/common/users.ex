defmodule Common.Users do
  @moduledoc """
  The Admins context.
  """

  import Ecto.Query, warn: false
  alias Qiibee.Repo

  alias Common.Users.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(id) do
    Repo.one(from(u in User, where: u.id == ^id))
  end
end
