# frozen_string_literal: true

module Presentation
  class Bot
    module Responses
      class Button < Dry::Struct
        attribute :text, Types::Strict::String
        attribute :callback_data, Types::Strict::String
      end
    end
  end
end
