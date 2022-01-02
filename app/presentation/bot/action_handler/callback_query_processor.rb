# frozen_string_literal: true

module Presentation
  class Bot
    class ActionHandler
      class CallbackQueryProcessor
        include Import[
          'presentation.bot.actions.callback_query.settings',
          'presentation.bot.actions.callback_query.opt_in',
          'presentation.bot.actions.callback_query.opt_out',
          'presentation.bot.actions.callback_query.available_blogs',
          'presentation.bot.actions.callback_query.enabled_blogs',
          'presentation.bot.actions.callback_query.subscribe',
          'presentation.bot.actions.callback_query.unsubscribe'
        ]

        include Dry::Effects::Handler.Reader(:action_processor)

        include Dry::Monads::Result::Mixin

        def call(chat_id:, message_id:, data:)
          with_action_processor(self) do
            case callback_query.data
            in /^settings$/
              settings.call(chat_id, message_id)
            in /^opt_in$/
              subscribe.call(chat_id, message_id)
            in /^opt_out$/
              unsubscribe.call(chat_id, message_id)
            in /^available_blogs/
              available_blogs.call(chat_id, message_id, data)
            in /^enabled_blogs/
              enabled_blogs.call(chat_id, message_id, data)
            in /^subscribe/
              disable_blog.call(chat_id, message_id, data)
            in /^unsubscribe/
              enable_blog.call(chat_id, message_id, data)
            else
              Success(:unmatched)
            end
          end
        end
      end
    end
  end
end
