# frozen_string_literal: true

module Application
  module Operations
    module Chat
      class ListBlogStatuses
        include Import['application.ports.repositories.blog_repo']

        include Dry::Monads::Result::Mixin
        include Dry::Monads::Do.for(:call)

        def call(chat_uid)
          blogs = blog_repo.all_with_subscription_status(chat_uid)

          Success(blogs)
        end
      end
    end
  end
end
