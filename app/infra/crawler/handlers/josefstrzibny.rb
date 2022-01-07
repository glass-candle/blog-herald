# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Josefstrzibny
        include Import['core.infra.http_client']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        URL = 'https://nts.strzibny.name/'

        def call
          html_page = yield http_client.execute_request(URL, method: :get)
          parse_page(html_page)
        end

        private

        def parse_page(html_page)
          articles = html_page.css("//div[@class='main']/div/h3")
          posts = articles.map do |article|
            link_title = article.at_css('a')
            title = link_title.text
            href = link_title['href']

            parsed_href = URI.parse(href)
            link = if parsed_href.host
              link_title['href']
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
