# frozen_string_literal: true

module Presentation
  module Jobs
    class KillSelenium < BaseJob
      # Kill all chrome processes once in a while for safe measure
      def perform
        `kill -9 $(ps aux | grep 'chrom' | awk '{print $2}')` if App.env == :production
      end
    end
  end
end
