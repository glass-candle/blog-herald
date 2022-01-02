# frozen_string_literal: true

module Core
  module Application
    module Ports
      class BaseRepository < ROM::Repository::Root
        struct_namespace Domain::Entities

        class << self
          def new
            super(App[:rom_container])
          end
        end

        def find(id)
          root.by_pk(id).one
        end

        def all
          root.to_a
        end
      end
    end
  end
end
