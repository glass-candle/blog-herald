# frozen_string_literal: true

module Domain
  module Entities
    class Blog < ROM::Struct
      attribute :codename, Types::Strict::String
      attribute :title, Types::Strict::String
      attribute :link, Types::Strict::String
    end
  end
end
