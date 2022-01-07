# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Kirshatrov
        include Import['core.infra.http_client']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        URL = 'https://kirshatrov.com/posts/'

        def call
          html_page = yield http_client.execute_request(URL, method: :get)
          parse_page(html_page)
        end

        private

        def parse_page(html_page)
          container_html = html_page.at_css("//*[@class='text-base leading-8']")
          articles_html = container_html.css("div[@class='text-gray-900 hover:text-palette-a hover:underline']")
          articles = articles_html.map { |article_html| parse_article(article_html) }

          Success(articles)
        rescue StandardError => e
          Failure(msg: :parsing_failed, url: URL, exception: e)
        end

        def parse_article(article_html)
          anchor_html = article_html.at_css('a')

          href = anchor_html['href']
          parsed_href = URI.parse(href)
          link = if parsed_href.host
            anchor_html['href']
          else
            host = URI.parse(URL).host
            URI::HTTP.build(host: host, path: href).to_s
          end

          title = anchor_html.text

          Crawler::PostDTO.new(title, link)
        end
      end
    end
  end
end
