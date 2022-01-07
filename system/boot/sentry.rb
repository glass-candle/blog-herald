# frozen_string_literal: true

App.boot(:sentry) do |container|
  init do
    use :utils

    require 'sentry-ruby'
    require 'sentry-sidekiq'

    Sentry.init do |config|
      config.dsn = container[:settings].sentry_dsn

      config.background_worker_threads = 5
      config.sample_rate = 1
    end

    class SentryAdapter
      class << self
        def capture_exception(exception)
          Sentry.capture_exception(exception)
        end

        def capture_message(message)
          Sentry.capture_message(message)
        end

        def add_tags(**tags)
          Sentry.set_tags(**tags) unless tags.empty?
        end

        def add_breadcrumb(data, category, message)
          Sentry.add_breadcrumb(
            Sentry::Breadcrumb.new(
              data: { data: data },
              category: category,
              message: message
            )
          )
        end

        def flush
          Sentry.configure_scope(&:clear)
        end
      end
    end

    container.register(:sentry_adapter, SentryAdapter)
  end
end
