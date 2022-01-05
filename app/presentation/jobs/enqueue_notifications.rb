# frozen_string_literal: true

module Presentation
  module Jobs
    class EnqueueNotifications < BaseJob
      include Import['application.operations.notifications.aggregate_posts_by_chats']

      sidekiq_options retry: 5

      attr_reader :send_notificaiton

      def initialize(*arguments, send_notification: Presentation::Jobs::SendNotification, **dependencies)
        @send_notificaiton = send_notification

        super(*arguments, **dependencies)
      end

      def perform
        tuples = aggregate_posts_by_chats.call.value!

        tuples.each do |tuple|
          send_notificaiton.perform_async(tuple.chat_id, tuple.post_ids)
        end
      end
    end
  end
end
