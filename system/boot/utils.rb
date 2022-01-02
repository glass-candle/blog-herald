# frozen_string_literal: true

App.boot(:utils) do
  init do
    module Types
      include Dry.Types()
    end

    require 'dry-validation'
    require 'dry-struct'
    require 'dry/monads/all'
    require 'dry-transformer'
    require 'dry-types'
    require 'dry/effects'
    Dry::Validation.load_extensions(:monads)
    Import = App.injector

    require 'oj'
    require 'typhoeus'
  end
end
