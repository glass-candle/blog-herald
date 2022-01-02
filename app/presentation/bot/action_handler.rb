# frozen_string_literal: true

module Presentation
  class Bot
    class ActionHandler
      include Import[
        'presentation.bot.action_handler.callback_query_processor',
        'presentation.bot.action_handler.message_processor'
      ]

      include Dry::Effects.Reader(:bot_adapter)

      def call(payload_object)
        handle_result(
          payload_object,
          process(payload_object)
        )
      end

      private

      def process(payload_object)
        case payload_object
        in Telegram::Bot::Types::CallbackQuery => callback_query
          callback_query_processor.call(
            chat_id: callback_query.message.chat.id,
            message_id: callback_query.message.message_id,
            data: callback_query.data
          )
        in Telegram::Bot::Types::Message => message
          message_processor.call(
            chat_id: message.chat.id
          )
        else
          Success(:unknown_payload_type)
        end
      end

      def handle_result(payload_object, _result)
        chat_id =
          case payload_object
          in Telegram::Bot::Types::CallbackQuery => callback_query
            callback_query.message.chat.id
          in Telegram::Bot::Types::Message => message
            message.chat.id
          end

        bot_adapter.send_message(chat_id: chat_id, text: 'Whoops! Something went wrong, try again.')
      end
    end
  end
end
