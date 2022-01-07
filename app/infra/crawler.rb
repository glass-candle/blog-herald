# frozen_string_literal: true

module Infra
  class Crawler
    include Import['infra.crawler.handler_resolver']

    include Dry::Monads::Do.for(:call)
    include Dry::Monads::Result::Mixin

    PostDTO = Struct.new(:title, :link)

    def call(blog)
      handler_instance = yield resolve(blog.codename)
      post_dtos = yield handler_instance.call

      Success(post_dtos)
    end

    private

    def resolve(codename)
      handler_resolver.call(codename)
    end
  end
end
