# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Ilyabylich
        include Import['core.infra.http_client']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        URL = 'https://ilyabylich.svbtle.com/'

        def call
          html_page = yield http_client.execute_request(URL, method: :get)
          parse_page(html_page)
        end

        private

        def parse_page(html_page)
          container_html = html_page.at_css("//*[@class='blog user_home']")
          articles_html = container_html.css("*[@class='post user_show']")
          first_article = parse_first_article(articles_html[0])
          rest = articles_html[1..].map { |article_html| parse_normal_article(article_html) }

          Success([first_article, *rest])
        rescue StandardError => e
          Failure(msg: :parsing_failed, url: URL, exception: e)
        end

        def parse_first_article(article_html)
          header_html = article_html.at_css("h1[@class='article_title']")
          anchor_html = header_html.at_css('a')
          title = anchor_html.text
          link = anchor_html['href']

          Crawler::PostDTO.new(title, link)
        end

        def parse_normal_article(article_html)
          header_html = article_html.at_css("h1[@class='article_title']")
          title = header_html.text
          link = header_html.at_css('a')['href']

          Crawler::PostDTO.new(title, link)
        end
      end
    end
  end
end
