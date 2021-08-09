defmodule Common.Factory do
  use ExMachina.Ecto, repo: Qiibee.Repo

  alias Common.{Admins.Admin, Brands.Brand, Users.User}

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

  def user_factory do
    brand = insert(:brand)

    %User{
      name: Faker.Person.En.name(),
      email: Faker.Internet.free_email(),
      phone: Faker.Phone.EnUs.phone(),
      language: "en",
      brand: brand,
      brand_id: brand.id
    }
  end
end
