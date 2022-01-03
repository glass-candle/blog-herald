# frozen_string_literal: true

module Presentation
  class Bot
    class ActionHandler
      include Import[
        'presentation.bot.action_handler.callback_query_processor',
        'presentation.bot.action_handler.message_processor'
      ]

      include Dry::Effects.Reader(:bot_adapter)

      include Dry::Monads::Result::Mixin

      def call(payload_object)
        handle_result(
          payload_object,
          process(payload_object)
        )
      end

      private

      def process(payload_object)
        case payload_object
        in Bot::CallbackQuery => callback_query
          callback_query_processor.call(
            chat_id: callback_query.chat_id,
            message_id: callback_query.message_id,
            data: callback_query.data
          )
        in Bot::Message => message
          message_processor.call(
            chat_id: message.chat_id,
            text: message.text
          )
        else
          Success(:unknown_payload_type)
        end
      end

      def handle_result(payload_object, result)
        return result if result.success?

        chat_id =
          case payload_object
          in Bot::CallbackQuery => callback_query
            callback_query.chat_id
          in Bot::Message => message
            message.chat_id
          end

        bot_adapter.send_message(chat_id: chat_id, text: 'Whoops! Something went wrong, try again.')

        result
      end
    end
  end
end
