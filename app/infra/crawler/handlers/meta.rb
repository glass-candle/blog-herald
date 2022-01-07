# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Meta
        include Import['core.infra.http_client']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        URL = 'https://engineering.fb.com/feed/'

        def call
          xml_document = yield http_client.execute_request(URL, method: :get)
          parse_page(xml_document)
        end

        private

        def parse_page(xml_document)
          articles = xml_document.xpath('/rss/channel/item')
          posts = articles.map do |article|
            title = article.xpath('title').text
            link = article.xpath('link').text

            Crawler::PostDTO.new(title, link)
          end

          Success(posts)
        rescue StandardError => e
          Failure(msg: :parsing_failed, url: URL, exception: e)
        end
      end
    end
  end
end
