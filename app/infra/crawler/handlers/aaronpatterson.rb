# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Aaronpatterson
        include Import['core.infra.http_client']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        URL = 'https://tenderlovemaking.com/'

        def call
          html_page = yield http_client.execute_request(URL, method: :get)
          parse_page(html_page)
        end

        private

        def parse_page(html_page)
          articles = html_page.css("//div[@class='container']/article/div[@class='post']/h1/a")
          posts = articles.map do |article|
            title = article.text
            href = article['href']

            parsed_href = URI.parse(href)
            link = if parsed_href.host
              article['href']
            else
              host = URI.parse(URL).host
              URI::HTTP.build(host: host, path: href).to_s
            end

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
