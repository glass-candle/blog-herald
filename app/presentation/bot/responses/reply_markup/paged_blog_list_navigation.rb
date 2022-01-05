# frozen_string_literal: true

module Presentation
  class Bot
    module Responses
      module ReplyMarkup
        class PagedBlogListNavigation
          def render(path:, paged_blogs:, current_page:, total_pages:)
            button_rows = [
              navigation_buttons(path),
              *blog_actions(paged_blogs, path),
              pagination_buttons(current_page, total_pages, path)
            ]

            Responses::Keyboard.new(button_rows: button_rows)
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
              Responses::Button.new(text: '↩️ Back', callback_data: 'settings'),
              Responses::Button.new(text: text, callback_data: callback_data)
            ]
          end

          def blog_actions(paged_blogs, redirect_path)
            paged_blogs.filter_map do |paged_blog|
              next unless paged_blog[:in_page]

              blog = paged_blog[:item]
              text = blog.subscribed ? "❌ Unsubscribe from #{blog.title}" : "✅ Subscribe to #{blog.title}"
              callback_data = blog.subscribed ? "unsubscribe:#{blog.codename}|#{redirect_path}" : "subscribe:#{blog.codename}|#{redirect_path}"

              Responses::Button.new(text: text, callback_data: callback_data)
            end
          end

          def pagination_buttons(current_page, total_pages, redirect_path) # rubocop:disable Metrics/CyclomaticComplexity
            buttons = []
            return buttons if total_pages.zero?

            callback_path =
              case redirect_path
              in /^enabled_blogs/
                'enabled_blogs'
              in /^available_blogs/
                'available_blogs'
              end

            buttons << Responses::Button.new(text: '⏮ First', callback_data: "#{callback_path}:0") if current_page.positive? && current_page != 1
            buttons << Responses::Button.new(text: '⏪ Previous', callback_data: "#{callback_path}:#{current_page - 1}") if current_page - 1 >= 0
            buttons << Responses::Button.new(text: '⏩ Next', callback_data: "#{callback_path}:#{current_page + 1}") if current_page + 1 <= total_pages
            if current_page < total_pages && current_page != total_pages - 1
              buttons << Responses::Button.new(text: '⏭ Last', callback_data: "#{callback_path}:#{total_pages}")
            end

            buttons
          end
        end
      end
    end
  end
end
