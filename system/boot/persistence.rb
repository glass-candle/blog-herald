# frozen_string_literal: true

App.boot(:persistence) do |container|
  init do
    use :utils
    use :logger
    use :settings

    require 'pg'
    require 'rom'
    require 'rom-sql'

    use :zeitwerk
  end

  start do
    # TODO: configure an SSL connection

    options = {
      encoding: 'UTF8',
      connect_timeout: 10
    }

    connection_string = container[:settings].database_url

    rom_container = ROM.container(:sql, Sequel.connect(connection_string), options) do |config|
      config.auto_registration(File.expand_path('app/infra/persistence'), namespace: 'Infra::Persistence')

      logger = container[:logger]['database_logger']
      logger.level = container.env == :production ? :error : (container[:settings].database_logger_level || :trace)
      config.gateways[:default].use_logger logger
    end

    register(:rom_container, rom_container)
  end
end
