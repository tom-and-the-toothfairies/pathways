FROM ubuntu:16.04
MAINTAINER Eoin Houlihan <ehoulih@tcd.ie>

RUN apt-get -qq update && apt-get -qq -y install curl
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN curl -sL -O https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb

RUN apt-get -qq update && apt-get -qq -y install \
    build-essential \
    elixir \
    esl-erlang \
    git \
    nodejs

COPY . /opt/panacea
WORKDIR /opt/panacea

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV MIX_ENV prod

RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get && mix compile && npm install
RUN ./node_modules/brunch/bin/brunch build --production && mix phoenix.digest

CMD ["mix", "phoenix.server"]
