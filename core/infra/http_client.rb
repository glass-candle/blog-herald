# frozen_string_literal: true

module Core
  module Infra
    class HTTPClient
      include Dry::Monads::Do.for(:process_response)

      include Dry::Monads::Result::Mixin
      include Dry::Monads::Maybe::Mixin

      def execute_request(url, options)
        response = App[:typhoeus_adapter].run_http_request(
          url,
          options
        )

        process_response(response)
      end

      private

      def process_response(response)
        yield check_status(response)
        extract_body(response)
      end

      def check_status(response)
        return Success(response) if response.success?

        return Failure(msg: :request_timeout, response: response) if response.timed_out?

        Failure(msg: :response_unsuccessful, response: response)
      end

      def extract_body(response)
        body = Maybe(response.body).value_or({})

        if body.empty?
          Failure(msg: :empty_body, body: body, response: response)
        else
          parse_body(response, body)
        end
      end

      def parse_body(response, body)
        headers = response.headers

        case headers['Content-Type']
        in %r{text/html}
          Success(Nokogiri::HTML.parse(body))
        in /(rss)|(xml)/
          Success(Nokogiri::XML.parse(body))
        in /json/
          Success(Oj.load(body, symbol_keys: true))
        else
          Failure(msg: :unknown_content_type, content_type: headers['Content-Type'], response: response)
        end
      rescue Oj::Error => e
        Failure(msg: :json_parser_error, exception: e, response: response)
      end
    end
  end
end
