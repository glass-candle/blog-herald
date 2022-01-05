# frozen_string_literal: true

module Domain
  module Entities
    class Post < ROM::Struct
      attribute :title, Types::Strict::String
      attribute :link, Types::Strict::String
    end
  end
end
