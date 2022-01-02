# frozen_string_literal: true

module Application
  module Operations
    module Chat
      class OptInStatus
        include Import['application.ports.repositories.chat_repo']

        include Dry::Monads::Result::Mixin
        include Dry::Monads::Do.for(:call)

        def call(chat_uid)
          chat = chat_repo.by_chat_uid(chat_uid)
          chat.nil? ? Success(false) : Success(true)
        end
      end
    end
  end
end
