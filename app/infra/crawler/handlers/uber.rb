# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Uber
        include Import['core.infra.http_client']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        URL = 'https://eng.uber.com/'

        def call
          html_page = yield http_client.execute_request(
            URL,
            headers: {
              'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6)' \
                'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
              'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            method: :get
          )
          parse_page(html_page)
        end

        private

        def parse_page(html_page)
          articles = html_page.css("//h3[@class='entry-title td-module-title']")
          posts = articles.map do |article|
            link_title = article.at_css('a')
            title = link_title.text
            link = link_title['href']

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
