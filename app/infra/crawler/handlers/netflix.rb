# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Netflix
        include Import['core.infra.http_client']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        URL = 'https://medium.com/feed/netflix-techblog'

        def call
          xml_document = yield http_client.execute_request(URL, method: :get)
          parse_page(xml_document)
        end

        private

        def parse_page(xml_document)
          articles = xml_document.xpath('/rss/channel/item')
          posts = articles.map do |article|
            title = article.xpath('title').text
            url = URI.parse(article.xpath('link').text)
            url.query = nil

            Crawler::PostDTO.new(title, url.to_s)
          end

          Success(posts)
        rescue StandardError => e
          Failure(msg: :parsing_failed, url: URL, exception: e)
        end
      end
    end
  end
end
