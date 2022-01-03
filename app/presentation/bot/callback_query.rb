# frozen_string_literal: true

module Presentation
  class Bot
    class CallbackQuery < Dry::Struct
      attribute :chat_id, Types::Coercible::String
      attribute :message_id, Types::Coercible::String
      attribute :data, Types::Strict::String
    end
  end
end
