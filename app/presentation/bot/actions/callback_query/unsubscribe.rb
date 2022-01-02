# frozen_string_literal: true

module Presentation
  class Bot
    module Actions
      module CallbackQuery
        class Unsubscribe
          include Import[
            'application.operations.chat.unsubscribe'
          ]

          include Actions::Params.new(prefix: 'unsubscribe')

          include Dry::Effects.Reader(:action_processor)

          include Dry::Monads::Do.for(:call)

          def call(chat_id, message_id, path)
            codename, callback_path = params(path)
            yield unsubscribe.call(chat_id, codename)

            action_processor.call(chat_id: chat_id, message_id: message_id, data: callback_path)
          end
        end
      end
    end
  end
end
