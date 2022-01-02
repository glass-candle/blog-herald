# frozen_string_literal: true

module Presentation
  class Bot
    module Actions
      class Pagination < Module
        def initialize(prefix:)
          regexp = Regexp.new("#{prefix}:(?<page>[0-9]+)")

          define_paginate(regexp)

          super()
        end

        private

        def define_paginate(regexp)
          define_method(:paginate) do |path, collection, page_size|
            page = regexp.match(path)&.[]('page')
            raise ArgumentError, 'invalid page' unless page

            pages_count = collection.size / PAGE_SIZE
            page_number = page > pages_count || page.negative? ? 0 : page.to_i

            page_range = (page_number * page_size)..(page_number * page_size + page_size) - 1
            paged_collection = collection.map.with_index { |item, index| { item: item, in_page: page_range.include?(index) } }

            [page_number, page_count, paged_collection]
          end
        end
      end
    end
  end
end
