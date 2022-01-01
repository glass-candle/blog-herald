# frozen_string_literal: true

module Infra
  module Persistence
    module Relations
      class Blogs < ROM::Relation[:sql]
        schema(:blogs, infer: true) do
          associations do
            has_many :chats_blogs
            has_many :chats, through: :chats_blogs
          end
        end
      end
    end
  end
end
