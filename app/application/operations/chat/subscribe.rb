# frozen_string_literal: true

module Application
  module Operations
    module Chat
      class Subscribe
        include Import[
          'application.contracts.subscription_contract',
          'application.ports.repositories.chat_repo',
          'application.ports.repositories.blog_repo'
        ]

        include Dry::Monads::Result::Mixin
        include Dry::Monads::Do.for(:call)

        def call(chat_uid, blog_codename)
          blog = blog_repo.by_codename(blog_codename)
          return Failure(:blog_not_found) unless blog

          chat = chat_repo.by_chat_uid(chat_uid)
          return Failure(:chat_not_found) unless chat

          yield subscription_contract.call(chat_uid, blog_codename)
          chat_repo.subscribe_to_blog(chat, blog)

          Success(blog)
        end
      end
    end
  end
end
