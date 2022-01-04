# frozen_string_literal: true

module Presentation
  class Bot
    module Actions
      module CallbackQuery
        class AvailableBlogs
          include Import[
            'application.operations.chat.opt_in_status',
            'application.operations.chat.list_blog_statuses',
            'presentation.bot.responses.text.subscription_blog_list',
            'presentation.bot.responses.text.blog_list',
            'presentation.bot.responses.reply_markup.paged_blog_list_navigation',
            'presentation.bot.responses.reply_markup.blog_list_navigation'
          ]

          include Actions::Pagination.new(prefix: 'available_blogs')

          include Dry::Effects.Reader(:bot_adapter)

          include Dry::Monads::Do.for(:call)

          PAGE_SIZE = 5

          def call(chat_id, message_id, path)
            is_opted_in = yield opt_in_status.call(chat_id)
            blogs = yield list_blog_statuses.call(chat_id)

            text, reply_markup = generate_reply_data(path, blogs, is_opted_in)

            bot_adapter.edit_message_text(
              chat_id: chat_id,
              message_id: message_id,
              disable_web_page_preview: true,
              text: text,
              reply_markup: reply_markup
            )
          end

          private

          def generate_reply_data(path, blogs, is_opted_in)
            case is_opted_in
            in true
              current_page, total_pages, paged_blogs = paginate(path, blogs, PAGE_SIZE)
              text = subscription_blog_list.render(paged_blogs: paged_blogs, only_subscribed: false)
              reply_markup = paged_blog_list_navigation.render(
                path: path,
                paged_blogs: paged_blogs,
                current_page: current_page,
                total_pages: total_pages
              )

              [text, reply_markup]
            in false
              text = blog_list.render(blogs: blogs)
              reply_markup = blog_list_navigation.render

              [text, reply_markup]
            end
          end
        end
      end
    end
  end
end
