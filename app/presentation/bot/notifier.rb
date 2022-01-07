# frozen_string_literal: true

module Presentation
  class Bot
    class Notifier
      include Dry::Effects.Reader(:bot_adapter)

      include Dry::Monads::Result::Mixin

      POSTS_PER_MESSAGE = 20

      def call(chat_id, posts)
        texts = generate_texts(posts)

        results = texts.map do |text|
          case bot_adapter.send_message(chat_id: chat_id, text: text)
          in Failure(msg: :telegram_bot_exception) => failure
            App[:sentry_adapter].add_tags(chat_uid: chat_id)
            App[:sentry_adapter].add_breadcrumb(failure.failure, :failure, 'Failure')
            App[:sentry_adapter].add_breadcrumb(posts, :posts, 'Posts')
            App[:sentry_adapter].capture_message('Notification failure')
            failure
          in Success
            Success(:sent)
          end
        end

        results.all?(&:success?) ? Success(:all_sent) : Failure(msg: :not_all_sent, results: results)
      end

      private

      def generate_texts(posts)
        return [generate_single_text(posts)] if posts.size < POSTS_PER_MESSAGE

        messages_amount = (posts.size - 1) / POSTS_PER_MESSAGE
        (0..messages_amount).map do |message_number|
          paginated_posts = posts[message_number * POSTS_PER_MESSAGE..message_number * POSTS_PER_MESSAGE + POSTS_PER_MESSAGE]
          generate_single_text(paginated_posts)
        end
      end

      def generate_single_text(posts)
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
