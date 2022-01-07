# frozen_string_literal: true

module Presentation
  module Jobs
    class BaseJob
      include Sidekiq::Worker
    end
  end
end
