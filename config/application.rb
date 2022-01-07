# frozen_string_literal: true

require_relative 'boot'

require 'dry/system/container'
require 'dry/system/loader/autoloading'
require 'dry/system/components'

Inflector = Dry::Inflector.new do |inflections|
  inflections.acronym('HTTP')
end

class App < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch('APP_ENV', :development).to_sym }

  configure do |config|
    config.root = Pathname(Dir.getwd)
    config.inflector = Inflector

    config.component_dirs.loader = Dry::System::Loader::Autoloading
    config.component_dirs.add_to_load_path = false

    config.component_dirs.add 'app'
    config.component_dirs.add '.' do |dir|
      dir.auto_register = proc do |component|
        component.identifier.start_with?('core')
      end
    end
  end
end
