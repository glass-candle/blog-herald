# frozen_string_literal: true

module Presentation
  class Bot
    module Responses
      module Text
        class BlogList
          def render(blogs:)
            return 'No blogs available' if paged_blogs.empty?

            blog_list = blogs.map do |blog|
              "#{blog.title} - #{blog.link}"
            end.join("\n")

            <<~TEXT
              The following blogs are available:

              #{blog_list}
            TEXT
          end
        end
      end
    end
  end
end
