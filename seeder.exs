# Seed Admins

alias Common.{Admins, Brands, Codes, Rewards, Users}

require Logger

admins_len = 1..4
brands_per_admin_len = 1..3
one_day_in_seconds = 86400
five_day_in_seconds = one_day_in_seconds * 5

# Seed admins
admins =
  for _ <- admins_len do
    name = "#{Faker.Person.En.first_name()}-#{Faker.Person.En.last_name()}"

    case Admins.create_admin(%{
           username: String.downcase(name),
           name: name
         }) do
      {:ok, admin} ->
        admin

      error ->
        Logger.error("seeder.exs: Could not create admin. Reason: #{inspect(error)}")
        nil
    end
  end

# Seed Brands
brands =
  Enum.map(admins, fn admin ->
    for _ <- brands_per_admin_len do
      case Brands.create_brand(%{
             name: "Brand: #{Faker.Commerce.product_name()}",
             admin_id: admin.id
           }) do
        {:ok, brand} ->
          brand

        error ->
          Logger.error("seeder.exs: Could not create brand. Reason: #{inspect(error)}")
          nil
      end
    end
  end)

# Seed Codes
_codes =
  Enum.map(brands, fn brand_list ->
    for brand <- brand_list do
      case Codes.create_code(%{
             code: Faker.UUID.v4() |> String.replace("-", "") |> String.slice(1..9),
             expires_at:
               NaiveDateTime.add(
                 NaiveDateTime.utc_now(),
                 Enum.random(-one_day_in_seconds..five_day_in_seconds),
                 :second
               ),
             points: Enum.random(5..50),
             brand_id: brand.id
           }) do
        {:ok, code} ->
          code

        error ->
          Logger.error("seeder.exs: Could not create code. Reason: #{inspect(error)}")
          nil
      end
    end
  end)

# Seed Rewards
Enum.map(brands, fn brand_list ->
  for brand <- brand_list do
    case Rewards.create_reward(%{
           name: "Reward: #{Faker.Commerce.product_name()}",
           price_in_points: Enum.random(5..50),
           brand_id: brand.id
         }) do
      {:ok, rewards} ->
        rewards

      error ->
        Logger.error("seeder.exs: Could not create rewards. Reason: #{inspect(error)}")
        nil
    end
  end
end)

# Seed Users
Enum.map(brands, fn brand_list ->
  for brand <- brand_list do
    case Users.create_user(%{
           name: Faker.Person.En.name(),
           email: Faker.Internet.free_email(),
           phone: Faker.Phone.EnUs.phone(),
           language: "en",
           brand_id: brand.id
         }) do
      {:ok, user} ->
        user

      error ->
        Logger.error("seeder.exs: Could not create user. Reason: #{inspect(error)}")
        nil
    end
  end
end)
