# frozen_string_literal: true

module Presentation
  module Jobs
    class SourceBlogposts < BaseJob
      include Import['application.operations.blogs.source']

      include Dry::Monads::Result::Mixin

      sidekiq_options retry: 5

      def perform(blog_id)
        result = source.call(blog_id)

        case result
        in Failure
          App[:sentry_adapter].add_tags(blog_id: blog_id)
          App[:sentry_adapter].add_breadcrumb(blog_id, :blog_id, 'Blog ID')
          App[:sentry_adapter].add_breadcrumb(result.failure, :failure, 'Failure')
          App[:sentry_adapter].capture_message('Blog sourcing has failed')
          result.value!
        in Success
          result.value!
        end
      end
    end
  end
end
