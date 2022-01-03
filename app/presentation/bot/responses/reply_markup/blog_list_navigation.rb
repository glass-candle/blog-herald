# frozen_string_literal: true

module Presentation
  class Bot
    module Responses
      module ReplyMarkup
        class BlogListNavigation
          def render
            button_rows = [
              Responses::Button.new(text: '↩️ Back', callback_data: 'settings')
            ]

            Responses::Keyboard.new(button_rows: button_rows)
          end
        end
      end
    end
  end
end
