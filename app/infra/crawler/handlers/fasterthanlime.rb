# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Fasterthanlime
        include Import['core.infra.http_client']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        ARTICLES_URL = 'https://fasterthanli.me/articles'
        SERIES_URL = 'https://fasterthanli.me/series'

        def call
          results = [ARTICLES_URL, SERIES_URL].map do |url|
            html_page = yield http_client.execute_request(url, method: :get)
            parse_page(html_page, url)
          end

          results.all?(&:success?) ? Success(results.flat_map(&:success)) : Failure(msg: :parsing_failed, results: results)
        end

        private

        def parse_page(html_page, url) # rubocop:disable Metrics/AbcSize
          articles = html_page.css("//*[@class='post-link']")
          posts = articles.map do |article|
            span = article.at_css('span')
            title = span.text.chomp.strip
            href = article['href']

            parsed_href = URI.parse(href)
            link = if parsed_href.host
              article['href']
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
