# frozen_string_literal: true

module Application
  module Operations
    module Blogs
      class Source
        include Import[
          'application.ports.repositories.blog_repo',
          'application.ports.repositories.post_repo',
          'infra.crawler'
        ]

        include Dry::Monads::Do.for(:call)
        include Dry::Monads::Result::Mixin

        def call(blog_id)
          blog = blog_repo.with_posts(blog_id)
          post_dtos = yield crawler.call(blog)
          post_dtos = filter_post_dtos(post_dtos, blog.posts)
          posts = post_repo.create_posts(post_dtos, blog.id)

          Success(posts)
        end

        private

        def filter_post_dtos(post_dtos, posts)
          post_links = posts.map(&:link)
          post_dtos.reject { |post_dto| post_links.include?(post_dto.link) }
        end
      end
    end
  end
end
