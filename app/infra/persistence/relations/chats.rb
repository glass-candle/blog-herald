# frozen_string_literal: true

module Infra
  module Persistence
    module Relations
      class Chats < ROM::Relation[:sql]
        schema(:chats, infer: true) do
          associations do
            has_many :chats_blogs
            has_many :blogs, through: :chats_blogs
          end
        end
      end
    end
  end
end
