# frozen_string_literal: true

App.boot(:typhoeus_adapter) do |container|
  start do
    require 'typhoeus'

    class TyphoeusAdapter
      def run_http_request(url, options = {})
        request_options = options.merge(default_options)

        Typhoeus::Request.new(url, request_options).run
      end

      private

      def default_options
        {
          timeout: 5,
          connecttimeout: 3,
          ssl_verifypeer: false,
          followlocation: true,
          accept_encoding: 'gzip'
        }
      end
    end

    container.register(:typhoeus_adapter) { TyphoeusAdapter.new }
  end
end
