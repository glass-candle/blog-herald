# frozen_string_literal: true

App.boot(:settings, from: :system) do
  settings do
    key :app_env, Types::Coercible::Symbol.enum(:development, :test, :production)

    LoggerLevels = Types::Coercible::String.default('info').enum('fatal', 'error', 'warn', 'info', 'debug', 'trace')
    key :logger_level, LoggerLevels
    key :database_logger_level, LoggerLevels

    key :sentry_dsn, Types::Coercible::String.default('')

    key :database_url, Types::Coercible::String

    key :bot_token, Types::Coercible::String

    key :sidekiq_redis_url, Types::Coercible::String
  end
end
