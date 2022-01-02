# frozen_string_literal: true

module Presentation
  class Bot
    module Actions
      module CallbackQuery
        class Subscribe
          include Import[
            'application.operations.chat.subscribe'
          ]

          include Actions::Params.new(prefix: 'subscribe')

          include Dry::Effects.Reader(:action_processor)

          include Dry::Monads::Do.for(:call)

          def call(chat_id, message_id, path)
            codename, callback_path = params(path)
            yield subscribe.call(chat_id, codename)

            action_processor.call(chat_id: chat_id, message_id: message_id, data: callback_path)
          end
        end
      end
    end
  end
end
