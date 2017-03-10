FROM ruby:2.4-alpine
MAINTAINER Eoin Houlihan <ehoulih@tcd.ie>

# Preempt encoding issues
ENV LANG C.UTF-8

# GCC bits to compile native extensions
RUN apk --no-cache add build-base

RUN mkdir -p /opt/app
WORKDIR /opt/app

# Cache Ruby deps
COPY Gemfile Gemfile.lock ./
RUN bundle install -j4

COPY . .

CMD ["bundle", "exec", "cucumber", "--format", "junit", "--out", "/test-reports", "--format", "pretty"]
