# frozen_string_literal: true

App.boot(:zeitwerk) do
  init do
    use :utils
    # These are required since the application
    # code relies on constants defined in these
    # dependencies.
    use :sidekiq
    use :persistence

    require 'zeitwerk'

    module Core; end

    loader = Zeitwerk::Loader.new
    loader.inflector.inflect('http_client' => 'HTTPClient')
    loader.push_dir(App.config.root.join('app').realpath)
    loader.push_dir(App.config.root.join('core').realpath, namespace: Core)
    loader.setup

    loader.eager_load
  end
end
