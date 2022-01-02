# frozen_string_literal: true

module Presentation
  class Bot
    include Import['presentation.bot.action_handler']

    include Dry::Effects::Handler.Reader(:bot_adapter)

    def poll
      App[:bot_adapter].run do |bot_adapter|
        bot_adapter.listen do |payload_object|
          with_bot_adapter(bot_adapter) do
            action_handler.call(payload_object)
          end
        end
      end
    end
  end
end
