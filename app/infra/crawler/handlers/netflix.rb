# frozen_string_literal: true

module Infra
  class Crawler
    module Handlers
      class Netflix
        include Import['selenium_adapter']

        include Dry::Monads::Do.for(:call)

        include Dry::Monads::Result::Mixin

        URL = 'https://netflixtechblog.com/'

        def call
          articles = selenium_adapter.with_driver do |driver|
            driver.navigate.to(URL)
            waiter = selenium_adapter.waiter

            articles = waiter.until do
              driver.find_elements(:xpath, '//a[@data-post-id]')
            end

            articles.map do |element|
              { text: element.text, href: element['href'] }
            end
          end

          parse_articles(articles)
        end

        private

        def parse_articles(articles)
          posts = articles.map do |article|
            url = URI.parse(article[:href])
            url.query = nil
            Crawler::PostDTO.new(article[:text].split("\n").first, url.to_s)
          end

          Success(posts)
        rescue StandardError => e
          Failure(msg: :parsing_failed, url: URL, exception: e)
        end
      end
    end
  end
end
