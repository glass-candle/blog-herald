# frozen_string_literal: true

App.boot(:bot_adapter) do |container|
  init do
    use :utils
    use :settings

    require 'telegram/bot'

    class BotAdapter
      include Dry::Monads::Result::Mixin

      class << self
        def run
          Telegram::Bot::Client.run(App[:settings].bot_token) do |bot_client|
            bot_adapter = new(bot_client)
            yield(bot_adapter)
          end
        end
      end

      def initialize(bot_client)
        @bot_client = bot_client
      end

      def listen
        @bot_client.listen do |payload_object|
          payload_object =
            case payload_object
            in Telegram::Bot::Types::Message
              Presentation::Bot::Message.new(
                chat_id: payload_object.chat.id,
                text: payload_object.text
              )
            in Telegram::Bot::Types::CallbackQuery
              Presentation::Bot::CallbackQuery.new(
                chat_id: payload_object.message.chat.id,
                message_id: payload_object.message.message_id,
                data: payload_object.data
              )
            end

          yield(payload_object)
        end
      end

      def edit_message_text(chat_id:, message_id:, reply_markup:, **data)
        reply_markup = convert_keyboard(reply_markup)

        response = @bot_client.api.edit_message_text(
          chat_id: chat_id,
          message_id: message_id,
          reply_markup: reply_markup,
          **data
        )

        Success(response)
      rescue Telegram::Bot::Exceptions::Base => e
        Failure(msg: :telegram_bot_exception, exception: e)
      end

      def send_message(chat_id:, **data)
        arguments = { chat_id: chat_id, **data }

        arguments[:reply_markup] = convert_keyboard(data[:reply_markup]) if data[:reply_markup]

        response = @bot_client.api.send_message(arguments)

        Success(response)
      rescue Telegram::Bot::Exceptions::Base => e
        Failure(msg: :telegram_bot_exception, exception: e)
      end

      private

      def convert_keyboard(reply_markup)
        Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: reply_markup.button_rows.map do |row|
            case row
            in Array
              row.map do |button|
                Telegram::Bot::Types::InlineKeyboardButton.new(text: button.text, callback_data: button.callback_data)
              end
            else
              button = row
              Telegram::Bot::Types::InlineKeyboardButton.new(text: button.text, callback_data: button.callback_data)
            end
          end
        )
      end
    end

    container.register(:bot_adapter, BotAdapter)
  end
end
