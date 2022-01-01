# frozen_string_literal: true

App.boot(:zeitwerk) do
  init do
    use :utils

    require 'zeitwerk'

    module Core; end

    loader = Zeitwerk::Loader.new
    # loader.inflector.inflect()
    loader.push_dir(App.config.root.join('app').realpath)
    loader.push_dir(App.config.root.join('core').realpath, namespace: Core)
    loader.setup

    loader.eager_load
  end
end
