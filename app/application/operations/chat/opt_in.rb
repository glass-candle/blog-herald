# frozen_string_literal: true

module Application
  module Operations
    module Chat
      class OptIn
        include Import[
          'application.ports.repositories.chat_repo',
          'application.ports.repositories.blog_repo'
        ]

        include Dry::Monads::Result::Mixin
        include Dry::Monads::Do.for(:call)

        def call(chat_uid)
          chat = chat_repo.by_chat_uid(chat_uid)
          return Success(chat.to_h) unless chat.nil?

          all_blogs = blog_repo.all
          chat = chat_repo.create_with_blogs(chat_uid, all_blogs)

          Success(chat.to_h)
        end
      end
    end
  end
end
