# frozen_string_literal: true

module Presentation
  module Jobs
    class BaseJob
      include Sidekiq::Worker

      sidekiq_retries_exhausted do |message, exception|
      end
    end
  end
end
