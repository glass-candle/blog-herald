# frozen_string_literal: true

module Application
  module Operations
    module Chat
      class ListSubscribedBlogs
        include Import['application.ports.repositories.blog_repo']

        include Dry::Monads::Result::Mixin
        include Dry::Monads::Do.for(:call)

        def call(chat_uid)
          subscribed_blogs = blog_repo.all_with_subscription_status(chat_uid).select(&:subscribed)

          Success(subscribed_blogs)
        end
      end
    end
  end
end
