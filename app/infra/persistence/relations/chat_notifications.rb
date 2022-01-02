# frozen_string_literal: true

module Infra
  module Persistence
    module Relations
      class ChatNotifications < ROM::Relation[:sql]
        schema(:chat_notifications, infer: true) do
          associations do
            belongs_to :chat
            belongs_to :post
          end
        end
      end
    end
  end
end
