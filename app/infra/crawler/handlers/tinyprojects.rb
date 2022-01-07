# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Tinyprojects
        include Import['core.infra.http_client']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        BLOG_URL = 'https://tinyprojects.dev/blog'
        GUIDES_URL = 'https://tinyprojects.dev/guides'
        PROJECTS_URL = 'https://tinyprojects.dev/projects'

        def call
          results = [BLOG_URL, GUIDES_URL, PROJECTS_URL].map do |url|
            html_page = yield http_client.execute_request(url, method: :get)
            parse_page(html_page, url)
          end

          results.all?(&:success?) ? Success(results.flat_map(&:success)) : Failure(msg: :parsing_failed, results: results)
        end

        private

        def parse_page(html_page, url)
          articles = html_page.css('//ul/li')
          posts = articles.map do |article|
            link_title = article.at_css('a')
            title = link_title.text
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
