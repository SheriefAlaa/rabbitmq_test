defmodule ApiWeb.Plugs.AuthAdmin do
  @behaviour Plug

  import Plug.Conn

  alias Common.Brands.Brand
  alias Common.Brands

  def init(opts), do: opts

  def call(conn, _opts) do
    with [brand_id] <- get_req_header(conn, "x-api-key"),
         %Brand{} = brand <- Brands.get_brand(brand_id) do
      assign(conn, :current_brand, brand)
    else
      error ->
        IO.inspect(error, label: :brand_auth_error)

        conn
        |> put_status(403)
        |> Phoenix.Controller.put_view(ApiWeb.ErrorView)
        |> Phoenix.Controller.render("403.json")
        |> halt()
    end
  end
end
