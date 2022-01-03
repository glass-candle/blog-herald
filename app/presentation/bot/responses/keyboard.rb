# frozen_string_literal: true

module Presentation
  class Bot
    module Responses
      class Keyboard < Dry::Struct
        attribute :button_rows, Types::Strict::Array
      end
    end
  end
end
