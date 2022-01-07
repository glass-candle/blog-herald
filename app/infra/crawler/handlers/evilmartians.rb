# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Evilmartians
        include Import['core.infra.http_client']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        URL = 'https://evilmartians.com/chronicles'

        def call
          html_page = yield http_client.execute_request(URL, method: :get)
          parse_page(html_page)
        end

        private

        def parse_page(html_page)
          articles = html_page.css('/html/body/div/ul/li/a/article')
          posts = articles.map do |article|
            h1 = article.at_css('h1')
            title = h1.text
            meta = article.at_css("meta[@itemprop='mainEntityOfPage']")
            link = meta['content']

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
