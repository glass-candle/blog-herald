# frozen_string_literal: true

module Presentation
  class Bot
    module Responses
      module Text
        class SubscriptionBlogList
          def render(paged_blogs:, only_subscribed:)
            return empty_text(only_subscribed) if paged_blogs.empty?

            blog_list = paged_blogs.map do |paged_blog|
              blog = paged_blog[:item]
              text = paged_blog[:in_page] ? " > *#{blog.title} -* #{blog.link}" : "#{blog.title} - #{blog.link}"
              if only_subscribed
                "✅#{text}"
              else
                blog.subscribed ? "✅#{text}" : "❌#{text}"
              end
            end.join("\n")

            list_text(blog_list, only_subscribed)
          end

          private

          def empty_text(only_subscribed)
            case only_subscribed
            in true
              'You are not subscribed to any blogs.'
            in false
              'No blogs available.'
            end
          end

          def list_text(only_subscribed)
            case only_subscribed
            in true
              <<~TEXT
                You are subscribed to the following blogs:

                #{blog_list}
              TEXT
            in false
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
end
