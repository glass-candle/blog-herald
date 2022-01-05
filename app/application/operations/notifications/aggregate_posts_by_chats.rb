# frozen_string_literal: true

module Application
  module Operations
    module Notifications
      class AggregatePostsByChats
        include Import['application.ports.repositories.post_repo']

        include Dry::Monads::Result::Mixin

        def call
          tuples = post_repo.aggregate_relevant_by_chat_ids

          Success(tuples)
        end
      end
    end
  end
end
