# frozen_string_literal: true

module Presentation
  class Bot
    module Actions
      class Params < Module
        def initialize(prefix:)
          regexp = Regexp.new("#{prefix}:(?<param>[a-z]+)")

          define_params(regexp)

          super()
        end

        private

        def define_params(regexp)
          define_method(:params) do |path|
            current_path, callback_path = path.split('|')

            param = regexp.match(current_path)&.[]('param')
            raise ArgumentError, 'invalid param' unless param

            callback = /(?<callback_path>^[a-z_]+:[0-9]+$)/.match(callback_path)&.[]('callback_path')
            raise ArgumentError, 'invalid callback path' unless callback

            [param, callback]
          end
        end
      end
    end
  end
end
