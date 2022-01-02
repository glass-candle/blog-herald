# frozen_string_literal: true

module Presentation
  class Bot
    module Actions
      module CallbackQuery
        class Settings
          include Import[
            'application.operations.chat.opt_in_status',
            'presentation.bot.responses.reply_markup.settings_navigation',
            'presentation.bot.responses.text.settings_prompt'
          ]

          include Dry::Effects.Reader(:bot_adapter)

          include Dry::Monads::Do.for(:call)

          def call(chat_id)
            is_opted_in = yield opt_in_status.call(chat_id)

            bot_adapter.send_message(
              chat_id: chat_id,
              text: settings_prompt.render(is_opted_in: is_opted_in),
              reply_markup: settings_navigation.render(is_opted_in: is_opted_in)
            )
          end
        end
      end
    end
  end
end
