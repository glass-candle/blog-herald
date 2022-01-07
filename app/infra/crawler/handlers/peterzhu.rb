# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Peterzhu
        include Import['core.infra.http_client']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        URL = 'https://blog.peterzhu.ca/'

        def call
          html_page = yield http_client.execute_request(URL, method: :get)
          parse_page(html_page)
        end

        private

        def parse_page(html_page)
          container_html = html_page.at_css("//main[@aria-label='Content']")
          articles_html = container_html.css("article[@class='post-item']")
          articles = articles_html.map { |article_html| parse_article(article_html) }

          Success(articles)
        rescue StandardError => e
          Failure(msg: :parsing_failed, url: URL, exception: e)
        end

        def parse_article(article_html)
          anchor_html = article_html.at_css('div/h4/a')
          link = "#{URL}#{anchor_html['href']}"
          title = anchor_html.text

          Crawler::PostDTO.new(title, link)
        end
      end
    end
  end
end
