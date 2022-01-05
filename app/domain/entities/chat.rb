# frozen_string_literal: true

module Domain
  module Entities
    class Chat < ROM::Struct
      attribute :chat_uid, Types::Strict::String
    end
  end
end
