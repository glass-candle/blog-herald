# frozen_string_literal: true

module Application
  module Operations
    module Chat
      class OptOut
        include Import['application.ports.repositories.chat_repo']

        include Dry::Monads::Result::Mixin
        include Dry::Monads::Do.for(:call)

        def call(chat_uid)
          chat = chat_repo.by_chat_uid(chat_uid)
          return Success(chat_uid) if chat.nil?

          chat_repo.delete_by_chat_uid(chat_uid)

          Success(chat_uid)
        end
      end
    end
  end
end
