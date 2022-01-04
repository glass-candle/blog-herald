# frozen_string_literal: true

module Presentation
  class Bot
    module Responses
      module Text
        class SettingsPrompt
          def render(is_opted_in:)
            case is_opted_in
            in true
              "Hey! If you don't want to receive any more blogpost updates, press the 'Unsubscribe' button down below."
            in false
              "Hey! Press the 'Subscribe' button down below to start getting blogpost updates."
            end
          end
        end
      end
    end
  end
end
