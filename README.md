# Qiibee

## Description
SaaS Blockchain based project to help businesses track their codes/points/rewards.

## Components
1. API
2. Consumer (Broadway)
3. Database - MySQL (also the Blockchain layer)
4. Common Structs

## Running using Docker
```
    docker-compose up --build --remove-orphan
```
## Development
```
    docker-compose up --build # Comment out all services except db
    asdf install
    mix deps.get
    mix do ecto.create, ecto.migrate
    iex -S mix
```

## Features planned

1. API layer:
   - [ ] Admin
       - [ ] Auth
       - [ ] REST API
         - [ ] Check user's balance
         - [ ] Credit a certain user some points (Earn)
         - [ ] Debit a certain user some points (Burn
   - [ ] User
       - [ ] Auth
       - [ ] REST API
         - [ ] User registration
         - [ ] Redeem code to get points
         - [ ] Redeem reward using points
         - [ ] Transactions history

* Note: Each REST API operation will go through the API for validation first then get forwarded to RabbitMQ to be later consumed by Broadway.

2. Consumer layer:
   - [ ] Setup RabbitMQ
   - [ ] Connect to RabbitMQ
   - [ ] Create necessary queues/exchanges/dlxs
   - [ ] Create a queue seeder

3. Blockchain layer (Mock):
   - [ ] Create app
   - [ ] Create the balances table
   - [ ] Add necessary operations to be used by Broadway

4. Common structs app:
   - [x] Create admins
   - [x] Create brands (belongs to admins)
   - [x] Create users (belongs to brands)
   - [x] Create codes (belongs to brands)
   - [x] Create rewards (belongs to brands)