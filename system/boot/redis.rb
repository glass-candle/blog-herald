# frozen_string_literal: true

App.boot(:redis) do |container|
  init do
    use :utils
    use :settings

    require 'redis'
    require 'connection_pool'

    redis_url = container[:settings].redis_url
    pool_size = container[:settings].redis_pool_size

    redis = ConnectionPool.new(size: pool_size, timeout: 0.5) do
      Redis.new(url: redis_url, driver: :hiredis)
    end

    container.register(:redis, redis)
  end
end
