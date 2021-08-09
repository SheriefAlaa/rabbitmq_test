defmodule Blockchain.BlockchainTest do
  use Blockchain.DataCase

  import Common.Factory

  describe "blockchain" do
    test "earn/3 can add points to user's balance scoped by brand" do
      admin = insert(:admin)
      brand = insert(:brand_custom_admin, %{admin: admin})
      user = insert(:user, %{brand: brand})

      brand2 = insert(:brand_custom_admin, %{admin: admin})
      user2 = insert(:user, %{brand: brand2})

      assert {:ok, %{balance: 1000}} = Blockchain.earn(admin.id, user2.id, 1000)

      assert {:ok, %{balance: 12}} = Blockchain.earn(admin.id, user.id, 12)

      assert 12 == Blockchain.get_user_balance(user.id)
    end

    test "brun/3 can deduct points to user's balance scoped by brand" do
      admin = insert(:admin)
      brand = insert(:brand_custom_admin, %{admin: admin})
      user = insert(:user, %{brand: brand})

      brand2 = insert(:brand_custom_admin, %{admin: admin})
      user2 = insert(:user, %{brand: brand2})

      assert {:ok, %{balance: -1000}} = Blockchain.burn(admin.id, user2.id, -1000)

      assert {:ok, %{balance: 12}} = Blockchain.earn(admin.id, user.id, 12)
      assert 12 == Blockchain.get_user_balance(user.id)

      assert {:ok, %{balance: -10}} = Blockchain.burn(admin.id, user.id, 10)
      assert 2 == Blockchain.get_user_balance(user.id)
    end

    test "code_to_points/2 converts codes to points which are reflected in the user's balance" do
      admin = insert(:admin)
      brand = insert(:brand_custom_admin, %{admin: admin})

      code =
        insert(:code, %{
          brand: brand,
          expires_at: NaiveDateTime.add(NaiveDateTime.utc_now(), 86000)
        })

      user = insert(:user, %{brand: brand})

      assert {:ok, %{balance: 12}} = Blockchain.code_to_points(code.id, user.id)
    end

    test "code_to_points/2 refuses codes that expired" do
      admin = insert(:admin)
      brand = insert(:brand_custom_admin, %{admin: admin})

      code =
        insert(:code, %{
          brand: brand
        })

      user = insert(:user, %{brand: brand})

      assert {:error, :code_expired} = Blockchain.code_to_points(code.id, user.id)
    end

    test "code_to_points/2 errors if code was not found" do
      admin = insert(:admin)
      brand = insert(:brand_custom_admin, %{admin: admin})

      _existing_code =
        insert(:code, %{
          brand: brand
        })

      user = insert(:user, %{brand: brand})

      assert {:error, :code_not_found} = Blockchain.code_to_points(Ecto.UUID.generate(), user.id)
    end

    test "points_to_rewards/2 deducts points from user balance when the user buys a reward" do
      admin = insert(:admin)
      brand = insert(:brand_custom_admin, %{admin: admin})
      user = insert(:user, %{brand: brand})
      reward = insert(:reward, %{brand: brand, price_in_points: 50})
      assert {:ok, %{balance: 60}} = Blockchain.earn(admin.id, user.id, 60)
      assert {:ok, %{balance: -50}} = Blockchain.points_to_rewards(reward.id, user.id)
      assert 10 == Blockchain.get_user_balance(user.id)
    end

    test "points_to_rewards/2 errors if the points are less than the reward's price (in points)" do
      admin = insert(:admin)
      brand = insert(:brand_custom_admin, %{admin: admin})
      user = insert(:user, %{brand: brand})
      reward = insert(:reward, %{brand: brand, price_in_points: 150})
      assert {:ok, %{balance: 60}} = Blockchain.earn(admin.id, user.id, 60)
      assert {:error, :insufficient_funds} = Blockchain.points_to_rewards(reward.id, user.id)
      assert 60 == Blockchain.get_user_balance(user.id)
    end

    test "points_to_rewards/2 errors was not found" do
      admin = insert(:admin)
      brand = insert(:brand_custom_admin, %{admin: admin})
      user = insert(:user, %{brand: brand})
      assert {:ok, %{balance: 60}} = Blockchain.earn(admin.id, user.id, 60)

      assert {:error, :reward_not_found} =
               Blockchain.points_to_rewards(Ecto.UUID.generate(), user.id)

      assert 60 == Blockchain.get_user_balance(user.id)
    end
  end
end
