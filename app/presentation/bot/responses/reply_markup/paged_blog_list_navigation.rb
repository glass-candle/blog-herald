# frozen_string_literal: true

module Presentation
  class Bot
    module Responses
      module ReplyMarkup
        class PagedBlogListNavigation
          def render(path:, paged_blogs:, current_page:, total_pages:)
            keyboard = [
              navigation_buttons(path),
              blog_actions(paged_blogs, path),
              pagination_buttons(current_page, total_pages, path)
            ]

            Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
          end

          private

          def navigation_buttons(path)
            text, callback_data =
              case path
              in /available_blogs/
                ['❇️ Enabled blogs', 'enabled_blogs:0']
              in /enabled_blogs/
                ['🔠 Available blogs', 'available_blogs:0']
              end

            [
              Telegram::Bot::Types::InlineKeyboardButton.new(text: '↩️ Back', callback_data: 'settings'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: text, callback_data: callback_data)
            ]
          end

          def blog_actions(paged_blogs, redirect_path)
            paged_blogs.map do |paged_blog|
              blog = paged_blog[:item]
              text = blog.subscribed ? "❌ Unsubscribe from #{blog.title}" : "✅ Subscribe to #{blog.title}"
              callback_data = blog.subscribed ? "disable_blog:#{blog.codename}|#{redirect_path}" : "enable_blog:#{blog.codename}|#{redirect_path}"

              Telegram::Bot::Types::InlineKeyboardButton.new(text: text, callback_data: callback_data)
            end
          end

          def pagination_buttons(current_page, total_pages, redirect_path) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity
            buttons = []
            return buttons if total_pages.zero?

            callback_path =
              case redirect_path
              in /$enabled_blogs/
                'enabled_blogs'
              in /$available_blogs/
                'available_blogs'
              end

            if page_number.positive? && page_number != 1
              buttons << Telegram::Bot::Types::InlineKeyboardButton.new(text: '⏮ First', callback_data: "#{callback_path}:0")
            end
            if page_number - 1 >= 0
              buttons << Telegram::Bot::Types::InlineKeyboardButton.new(text: '⏪ Previous', callback_data: "#{callback_path}:#{current_page - 1}")
            end
            if page_number + 1 <= pages_count
              buttons << Telegram::Bot::Types::InlineKeyboardButton.new(text: '⏩ Next', callback_data: "#{callback_path}:#{current_page + 1}")
            end
            if page_number < pages_count && page_number != pages_count - 1
              buttons << Telegram::Bot::Types::InlineKeyboardButton.new(text: '⏭ Last', callback_data: "#{callback_path}:#{total_pages}")
            end

            buttons
          end
        end
      end
    end
  end
end
