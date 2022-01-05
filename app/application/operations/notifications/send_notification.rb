# frozen_string_literal: true

module Application
  module Operations
    module Notifications
      class SendNotification
        include Import[
          'application.ports.repositories.chat_notification_repo',
          'application.ports.repositories.post_repo',
          'application.ports.repositories.chat_repo',
          'presentation.bot'
        ]

        include Dry::Monads::Result::Mixin

        def call(chat_id, post_ids)
          actualized_post_ids = chat_notification_repo.all_post_ids_by_chat_id(chat_id)
          relevant_post_ids = post_ids - actualized_post_ids
          posts = post_repo.all_by_ids_with_blogs(relevant_post_ids)
          chat_uid = chat_repo.find(chat_id).chat_uid

          chat_notificaitons = chat_notification_repo.persist_notifications(chat_id, relevant_post_ids) do
            bot.notify(chat_uid, posts)
          end

          Success(chat_notificaitons)
        end
      end
    end
  end
end
