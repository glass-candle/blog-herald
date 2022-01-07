# frozen_string_literal: true

module Presentation
  module Jobs
    class EnqueueCrawlers < BaseJob
      include Import['application.operations.blogs.retrieve_blog_ids']

      sidekiq_options retry: 5

      attr_reader :source_blogposts

      def initialize(*arguments, source_blogposts: Presentation::Jobs::SourceBlogposts, **dependencies)
        @source_blogposts = source_blogposts

        super(*arguments, **dependencies)
      end

      def perform
        blog_ids = retrieve_blog_ids.call.value!

        blog_ids.each do |blog_id|
          source_blogposts.perform_async(blog_id)
        end
      end
    end
  end
end
