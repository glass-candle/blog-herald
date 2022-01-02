# frozen_string_literal: true

module Presentation
  class Bot
    class ActionHandler
      class MessageProcessor
        include Import['presentation.bot.actions.message.settings']

        include Dry::Monads::Result::Mixin

        def call(chat_id:)
          case message.text
          in %r{^/settings$}
            settings.call(chat_id)
          else
            Success(:unmatched)
          end
        end
      end
    end
  end
end
