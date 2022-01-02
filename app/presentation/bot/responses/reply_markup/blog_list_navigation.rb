# frozen_string_literal: true

module Presentation
  class Bot
    module Responses
      module ReplyMarkup
        class BlogListNavigation
          def render
            keyboard = [
              Telegram::Bot::Types::InlineKeyboardButton.new(text: '↩️ Back', callback_data: 'settings')
            ]

            Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
          end
        end
      end
    end
  end
end
