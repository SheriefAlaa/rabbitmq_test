defmodule Common.Factory do
  use ExMachina.Ecto, repo: Qiibee.Repo

  alias Common.{Admins.Admin, Codes.Code, Brands.Brand, Users.User, Rewards.Reward}

  def admin_factory do
    name = "#{Faker.Person.En.first_name()} #{Faker.Person.En.last_name()}"

    rand_int = Integer.to_string(Enum.random(1000..9000))

    username =
      name
      |> String.split(" ")
      |> Kernel.++([rand_int])
      |> Enum.join("-")

    %Admin{
      username: username,
      name: name
    }
  end

  def brand_factory do
    admin = insert(:admin)

    %Brand{
      name: "Brand: #{Faker.Commerce.product_name()}",
      admin: admin
    }
  end

  def brand_custom_admin_factory do
    %Brand{
      name: "Brand: #{Faker.Commerce.product_name()}",
      admin: build(:admin)
    }
  end

  def user_factory do
    brand = insert(:brand)

    %User{
      name: Faker.Person.En.name(),
      email: Faker.Internet.free_email(),
      phone: Faker.Phone.EnUs.phone(),
      language: "en",
      brand: brand
    }
  end

  def user_custom_brand_factory do
    %User{
      name: Faker.Person.En.name(),
      email: Faker.Internet.free_email(),
      phone: Faker.Phone.EnUs.phone(),
      language: "en",
      brand: build(:brand_custom_admin)
    }
  end

  def code_factory() do
    %Code{
      code: Faker.UUID.v4() |> String.replace("-", "") |> String.slice(1..9),
      expires_at: DateTime.utc_now(),
      points: 12,
      brand: build(:brand)
    }
  end

  def reward_factory() do
    %Reward{
      name: "Reward: #{Faker.Commerce.product_name()}",
      price_in_points: Enum.random(5..50),
      brand: build(:brand)
    }
  end
end
