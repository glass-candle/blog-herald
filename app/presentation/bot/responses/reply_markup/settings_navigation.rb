# frozen_string_literal: true

module Presentation
  class Bot
    module Responses
      module ReplyMarkup
        class SettingsNavigation
          def render(is_opted_in:)
            button_rows =
              case is_opted_in
              in true
                [
                  Responses::Button.new(text: '⏹ Unsubscribe', callback_data: 'unsubscribe'),
                  Responses::Button.new(text: '🔠 Available blogs', callback_data: 'available_blogs:0')
                ]
              in false
                [
                  Responses::Button.new(text: '▶️ Subscribe', callback_data: 'subscribe'),
                  Responses::Button.new(text: '🔠 Available blogs', callback_data: 'available_blogs:0')
                ]
              end

            Responses::Keyboard.new(button_rows: button_rows)
          end
        end
      end
    end
  end
end
