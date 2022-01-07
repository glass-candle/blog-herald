# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Rtcsec
        include Import['core.infra.http_client']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        POSTS_URL = 'https://www.rtcsec.com/post/'
        ARTICLES_URL = 'https://www.rtcsec.com/article/'
        NEWSLETTER_URL = 'https://www.rtcsec.com/newsletter/'

        def call
          results = [POSTS_URL, ARTICLES_URL, NEWSLETTER_URL].map do |url|
            html_page = yield http_client.execute_request(url, method: :get)
            parse_page(html_page, url)
          end

          results.all?(&:success?) ? Success(results.flat_map(&:success)) : Failure(msg: :parsing_failed, results: results)
        end

        private

        def parse_page(html_page, url) # rubocop:disable Metrics/AbcSize
          articles = html_page.css("//*[@id='main']//ul/li")
          posts = articles.map do |article|
            link_title = article.at_css('h2/a')
            title = link_title.text.chomp.strip
            href = link_title['href']

            parsed_href = URI.parse(href)
            link = if parsed_href.host
              link_title['href']
            else
              host = URI.parse(url).host
              URI::HTTP.build(host: host, path: href).to_s
            end

            Crawler::PostDTO.new(title, link)
          end

          Success(posts)
        rescue StandardError => e
          Failure(msg: :parsing_failed, url: url, exception: e)
        end
      end
    end
  end
end
