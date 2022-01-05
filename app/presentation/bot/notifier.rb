# frozen_string_literal: true

module Presentation
  class Bot
    class Notifier
      include Dry::Effects.Reader(:bot_adapter)

      include Dry::Monads::Result::Mixin

      def call(chat_id, posts)
        text = generate_text(posts)

        case bot_adapter.send_message(chat_id: chat_id, text: text)
        in Failure(msg: :telegram_bot_exception) => failure
          failure
        in Success
          Success(:sent)
        end
      end

      private

      def generate_text(posts)
        posts_by_blogs = posts.group_by(&:blog)
        multiple_blogs = posts_by_blogs.keys.size > 1

        text = multiple_blogs ? "The following blogs have new posts:\n\n" : "#{posts_by_blogs.keys.first.title} has new posts:\n\n"
        posts_by_blogs.each do |blog, blogposts|
          text += "#{blog.title}:\n" if multiple_blogs
          blogposts.each do |post|
            text += "#{post.title} - #{post.link}\n"
          end
          text += "\n" if multiple_blogs
        end
        text
      end
    end
  end
end
