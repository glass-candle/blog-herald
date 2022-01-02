# frozen_string_literal: true

module Presentation
  class Bot
    module Actions
      module CallbackQuery
        class EnabledBlogs
          include Import[
            'application.operations.chat.list_subscribed_blogs',
            'presentation.bot.responses.text.subscription_blog_list',
            'presentation.bot.responses.reply_markup.paged_blog_list_navigation'
          ]

          include Actions::Pagination.new(prefix: 'enabled_blogs')

          include Dry::Effects.Reader(:bot_adapter)

          include Dry::Monads::Do.for(:call)

          PAGE_SIZE = 5

          def call(chat_id, message_id, path)
            blogs = yield list_subscribed_blogs.call(chat_id)

            paged_blogs = yield paginate(path, blogs, PAGE_SIZE)
            text = subscription_blog_list.render(paged_blogs: paged_blogs, only_subscribed: true)
            reply_markup = paged_blog_list_navigation.render(paged_blogs: paged_blogs)

            bot_adapter.edit_message_text(
              chat_id: chat_id,
              message_id: message_id,
              parse_mode: 'markdown',
              disable_web_page_preview: true,
              text: text,
              reply_markup: reply_markup
            )
          end
        end
      end
    end
  end
end
