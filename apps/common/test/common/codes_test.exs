defmodule Common.CodesTest do
  use Common.DataCase

  alias Common.Codes

  import Common.Factory

  describe "codes" do
    alias Common.Codes.Code

    @valid_attrs %{
      code: "some code",
      expires_at: ~N[2010-04-17 14:00:00],
      points: 42,
      brand_id: nil
    }
    @update_attrs %{code: "some updated code", expires_at: ~N[2011-05-18 15:01:01], points: 43}
    @invalid_attrs %{code: nil, expires_at: nil, points: nil}

    def code_fixture(attrs \\ %{}) do
      admin = insert(:admin)
      brand = insert(:brand_custom_admin, %{admin: admin})

      {:ok, code} =
        attrs
        |> Enum.into(%{@valid_attrs | brand_id: brand.id})
        |> Codes.create_code()

      code
    end

    test "list_codes/0 returns all codes" do
      code = code_fixture()
      assert Codes.list_codes() == [code]
    end

    test "get_code!/1 returns the code with given id" do
      code = code_fixture()
      assert Codes.get_code!(code.id) == code
    end

    test "create_code/1 with valid data creates a code" do
      admin = insert(:admin)
      brand = insert(:brand_custom_admin, %{admin: admin})

      assert {:ok, %Code{} = code} = Codes.create_code(%{@valid_attrs | brand_id: brand.id})
      assert code.code == "some code"
      assert code.expires_at == ~N[2010-04-17 14:00:00]
      assert code.points == 42
    end

    test "create_code/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Codes.create_code(@invalid_attrs)
    end

    test "update_code/2 with valid data updates the code" do
      code = code_fixture()
      assert {:ok, %Code{} = code} = Codes.update_code(code, @update_attrs)
      assert code.code == "some updated code"
      assert code.expires_at == ~N[2011-05-18 15:01:01]
      assert code.points == 43
    end

    test "update_code/2 with invalid data returns error changeset" do
      code = code_fixture()
      assert {:error, %Ecto.Changeset{}} = Codes.update_code(code, @invalid_attrs)
      assert code == Codes.get_code!(code.id)
    end

    test "delete_code/1 deletes the code" do
      code = code_fixture()
      assert {:ok, %Code{}} = Codes.delete_code(code)
      assert_raise Ecto.NoResultsError, fn -> Codes.get_code!(code.id) end
    end

    test "change_code/1 returns a code changeset" do
      code = code_fixture()
      assert %Ecto.Changeset{} = Codes.change_code(code)
    end
  end
end
