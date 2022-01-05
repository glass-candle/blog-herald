# frozen_string_literal: true

module Application
  module Ports
    module Repositories
      class ChatNotificationRepo < Core::Application::Ports::BaseRepository[:chat_notifications]
        commands :create, use: :timestamps, plugins_options: { timestamps: { timestamps: %i[created_at updated_at] } }

        def all_post_ids_by_chat_id(chat_id)
          chat_notifications
            .select { [array.array_agg(post_id).as(:post_ids)] }
            .where(chat_id: chat_id)
            .group(:id)
            .to_a
        end

        def persist_notifications(chat_id, post_ids)
          chat_notifications.transaction do |t|
            create_changeset = chat_notifications
              .changeset(:create, post_ids.map { |post_id| { chat_id: chat_id, post_id: post_id } })
              .map(:add_timestamps)
            command_result = chat_notifications.command(:create, result: :many).call(create_changeset)

            callback_result = yield
            t.rollback! if callback_result.failure?
            command_result
          end
        end
      end
    end
  end
end
