# frozen_string_literal: true

App.boot(:persistence) do |container|
  init do
    use :utils
    use :logger
    use :settings

    require 'pg'
    require 'rom'
    require 'rom-sql'

    options = {
      encoding: 'UTF8',
      connect_timeout: 10
    }

    connection_string = container[:settings].database_url

    rom_config = ROM::Configuration.new(:sql, Sequel.connect(connection_string), options)

    register(:rom_config, rom_config)
  end

  start do
    rom_config = container[:rom_config]

    logger = container[:logger]['database_logger']
    logger.level = container.env == :production ? :error : (container[:settings].database_logger_level || :trace)
    rom_config.auto_registration(File.expand_path('app/infra/persistence'), namespace: 'Infra::Persistence')
    rom_config.gateways[:default].use_logger logger

    rom_container = ROM.container(rom_config)

    register(:rom_container, rom_container)
  end
end
