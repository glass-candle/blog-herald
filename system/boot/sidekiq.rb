# frozen_string_literal: true

App.boot(:sidekiq) do |container|
  init do
    use :utils
    use :redis
    use :settings

    require 'sidekiq'
    require 'sidekiq-scheduler'

    Sidekiq.configure_server do |config|
      config.redis = { url: container[:settings].redis_url }
    end
    Sidekiq.configure_client do |config|
      config.redis = { url: container[:settings].redis_url }
    end
  end
end
