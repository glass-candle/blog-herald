# frozen_string_literal: true

module Presentation
  class Bot
    module Actions
      module CallbackQuery
        class OptIn
          include Import[
            'application.operations.chat.opt_in',
            'presentation.bot.responses.text.settings_prompt',
            'presentation.bot.responses.reply_markup.settings_navigation'
          ]

          include Dry::Effects.Reader(:bot_adapter)

          include Dry::Monads::Do.for(:call)

          def call(chat_id, message_id)
            yield opt_in.call(chat_id)

            yield bot_adapter.send_message(chat_id: chat_id, text: 'You have successfully subscribed.')
            bot_adapter.edit_message_text(
              chat_id: chat_id,
              message_id: message_id,
              text: settings_prompt.render(is_opted_in: true),
              reply_markup: settings_navigation.render(is_opted_in: true)
            )
          end
        end
      end
    end
  end
end
