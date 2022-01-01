# frozen_string_literal: true

module Infra
  module Persistence
    module Relations
      class Posts < ROM::Relation[:sql]
        schema(:posts, infer: true) do
          associations do
            belongs_to :blog
          end
        end
      end
    end
  end
end
