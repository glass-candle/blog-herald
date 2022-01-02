# frozen_string_literal: true

module Infra
  module Persistence
    module Relations
      class ChatsBlogs < ROM::Relation[:sql]
        schema(:chats_blogs, infer: true) do
          associations do
            belongs_to :blogs, as: :blog
            belongs_to :chats, as: :chat
          end
        end
      end
    end
  end
end
