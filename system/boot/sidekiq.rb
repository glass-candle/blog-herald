# frozen_string_literal: true

App.boot(:sidekiq) do |container|
  init do
    use :utils
    use :settings

    require 'sidekiq'
    require 'sidekiq-scheduler'

    Sidekiq.configure_server do |config|
      config.redis = { url: container[:settings].sidekiq_redis_url }
    end
    Sidekiq.configure_client do |config|
      config.redis = { url: container[:settings].sidekiq_redis_url }
    end
  end
end
