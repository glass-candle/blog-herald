# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Mbuffett
        include Import['core.infra.http_client']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        URL = 'https://mbuffett.com/'

        def call
          html_page = yield http_client.execute_request(URL, method: :get)
          parse_page(html_page)
        end

        private

        def parse_page(html_page)
          articles = html_page.css("//li[@class='post-item']")
          posts = articles.map do |article|
            anchor = article.at_css('a')
            title = anchor.at_css("span[@class='post-title']").text
            link = anchor['href']

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
