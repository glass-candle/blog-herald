# frozen_string_literal: true

module Domain
  module Entities
    class Chat < ROM::Struct
      attribute :chat_uid, Types::Strict::Integer
    end
  end
end
