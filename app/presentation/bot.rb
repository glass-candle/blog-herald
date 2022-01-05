# frozen_string_literal: true

module Presentation
  class Bot
    include Import[
      'presentation.bot.action_handler',
      'presentation.bot.notifier'
    ]

    include Dry::Effects::Handler.Reader(:bot_adapter)

    include Dry::Monads::Result::Mixin

    def poll
      App[:bot_adapter].run do |bot_adapter|
        bot_adapter.listen do |payload_object|
          with_bot_adapter(bot_adapter) do
            action_handler.call(payload_object)
          end
        end
      rescue StandardError => e
        redo
      end
    end

    # at-most-once delivery
    def notify(chat_uid, posts)
      App[:bot_adapter].run do |bot_adapter|
        with_bot_adapter(bot_adapter) do
          notifier.call(chat_uid, posts)
        end
      end
    rescue StandardError => e
      Success(:sent)
    end
  end
end
