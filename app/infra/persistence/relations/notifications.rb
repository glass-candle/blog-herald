# frozen_string_literal: true

module Infra
  module Persistence
    module Relations
      class Notifications < ROM::Relation[:sql]
        schema(:notifications, infer: true) do
          associations do
            belongs_to :chat
            belongs_to :post
          end
        end
      end
    end
  end
end
