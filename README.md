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
## Run for development
```
    docker-compose up --build # Remember to comment the app service
    asdf install
    mix deps.get
    mix ecto.reset
    mix seed
    iex -S mix
```

## Monitoring RabbitMQ
Update Rabbit's user to admin
```
    docker exec -it qiibee_rabbitmq_1 /bin/bash

```
Visit web interface through `http://localhost:15672/` the username should be `user` and password is `pass`

## Features planned

1. API layer:
   - [ ] Admin
       - [ ] Auth
       - [ ] REST API
         - [ ] Check user's balance
         - [ ] Credit a certain user some points (Earn)
         - [ ] Debit a certain user some points (Burn)
   - [ ] User
       - [ ] Auth
       - [ ] REST API
         - [x] User registration
         - [ ] Redeem code to get points
         - [ ] Redeem reward using points
         - [ ] Transactions history
         - [x] Mock email service

* Note: Each REST API operation will go through the API for validation first then get forwarded to RabbitMQ to be later consumed by Broadway.

1. Consumer layer:
   1. hackney_pool setup
   - [x] Setup RabbitMQ (queues/exchanges/dlxs)
   - [x] Connect to RabbitMQ and test it
   - [x] Create a user registration queue (for emails)
   - [ ] api -> admin -> consumer / publisher
   - [ ] api -> user -> consumer / publisher
   <!-- - [ ] Create a queue seeder (Publisher that will be used by the API) -->

2. Blockchain layer (Mock):
   - [x] Create app
   - [x] Create the balances table
   - [x] Add necessary operations to be used by Broadway

3. Common structs app:
   - [x] Create admins
   - [x] Create brands (belongs to admins)
   - [x] Create users (belongs to brands)
   - [x] Create codes (belongs to brands)
   - [x] Create rewards (belongs to brands)
   - [x] Create a seeder