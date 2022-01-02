# frozen_string_literal: true

module Presentation
  class Bot
    module Responses
      module ReplyMarkup
        class SettingsNavigation
          def render(is_opted_in:)
            keyboard =
              case is_opted_in
              in true
                [
                  Telegram::Bot::Types::InlineKeyboardButton.new(text: '⏹ Unsubscribe', callback_data: 'unsubscribe'),
                  Telegram::Bot::Types::InlineKeyboardButton.new(text: '🔠 Available blogs', callback_data: 'available_blogs:0')
                ]
              in false
                [
                  Telegram::Bot::Types::InlineKeyboardButton.new(text: '▶️ Subscribe', callback_data: 'subscribe'),
                  Telegram::Bot::Types::InlineKeyboardButton.new(text: '🔠 Available blogs', callback_data: 'available_blogs:0')
                ]
              end

            Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
          end
        end
      end
    end
  end
end
