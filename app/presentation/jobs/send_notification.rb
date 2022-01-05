# frozen_string_literal: true

module Presentation
  module Jobs
    class SendNotification < BaseJob
      include Import['application.operations.notifications.send_notification']

      sidekiq_options retry: 0

      def perform(chat_id, post_ids)
        send_notification.call(chat_id, post_ids)
      end
    end
  end
end
