# frozen_string_literal: true

module Application
  module Operations
    module Blogs
      class RetrieveBlogIds
        include Import['application.ports.repositories.blog_repo']

        include Dry::Monads::Result::Mixin

        def call
          blog_ids = blog_repo.all.map(&:id)

          Success(blog_ids)
        end
      end
    end
  end
end
