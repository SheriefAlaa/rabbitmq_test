FROM elixir:1.11.2-slim

# Install system packages
RUN apt-get update
RUN apt-get install --yes --no-install-recommends \
  build-essential inotify-tools \
  default-mysql-client locales \
  git \
  tzdata

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8
RUN apt-get -qq clean

# Install application
ENV APP_ROOT /app
RUN mkdir -p ${APP_ROOT}

# Import env vars from compose's environment block
ARG DATABASE_URL
ARG SECRET_KEY_BASE
ARG MIX_ENV
ENV DATABASE_URL $DATABASE_URL
ENV SECRET_KEY_BASE $SECRET_KEY_BASE
ENV MIX_ENV $MIX_ENV

# Install and compile dependencies
WORKDIR ${APP_ROOT}
# ADD . .
ADD mix.exs mix.exs
ADD mix.lock mix.lock
ADD config config

# Install hex and rebar
RUN mix local.hex --force
RUN mix local.rebar --force
# Get deps and compile
RUN mix deps.get --only $MIX_ENV \
 && mix deps.compile

# copy remaining application files
WORKDIR ${APP_ROOT}
ADD . .

# build application
WORKDIR ${APP_ROOT}
RUN mix compile
