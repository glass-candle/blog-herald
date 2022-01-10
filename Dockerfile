FROM quay.io/evl.ms/fullstaq-ruby:3.0.1-jemalloc-slim

RUN \
    apt-get update -q \
    && apt-get dist-upgrade --assume-yes \
    && apt-get install --assume-yes -q --no-install-recommends \
      libffi-dev \
      make gcc libc-dev \
      libxml2 libxslt-dev g++ \
      libpq-dev postgresql-client \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log \
    && bundle config --global build.nokogiri --use-system-libraries

WORKDIR /app

COPY *Gemfile* /app/
RUN gem install bundler

RUN bundle install -j $(nproc)

ADD . /app/
