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
          Telegram::Bot::Client.run(container[:settings].bot_token) do |bot_client|
            bot_adapter = new(bot_client)
            yield(bot_adapter)
          end
        end
      end

      def initialize(bot_client)
        @bot_client = bot_client
      end

      def listen
        @bot_client.listen do |message|
          yield(message)
        rescue Telegram::Bot::Exceptions::Base => e
        end
      end

      def edit_message_text(chat_id:, message_id:, **data)
        response = @bot_client.api.edit_message_text(
          chat_id: chat_id,
          message_id: message_id,
          **data
        )

        Success(response)
      end

      def send_message(chat_id:, **data)
        response = @bot_client.api.send_message(chat_id: chat_id, **data)

        Success(response)
      end
    end

    container.register(:bot_adapter, BotAdapter)
  end
end
