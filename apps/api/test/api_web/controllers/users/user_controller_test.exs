defmodule ApiWeb.Users.UserControllerTest do
  use ApiWeb.ConnCase, async: false

  import Common.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      user_params = params_for(:user)
      conn = post(conn, Routes.users_user_path(conn, :register), user: user_params)

      assert %{"id" => _id} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.users_user_path(conn, :register), user: %{})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
