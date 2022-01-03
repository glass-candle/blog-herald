# frozen_string_literal: true

module Presentation
  class Bot
    class Message < Dry::Struct
      attribute :chat_id, Types::Coercible::String
      attribute :text, Types::Strict::String
    end
  end
end
