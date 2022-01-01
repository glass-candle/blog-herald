# frozen_string_literal: true

App.boot(:logger) do |container|
  init do
    use :utils

    require 'stringio'
    require 'semantic_logger'

    use :settings

    logger_level = container[:settings].logger_level

    SemanticLogger.default_level = logger_level
    SemanticLogger.application = :herald

    logger_stream = App.env == :test ? StringIO.new : $stdout
    SemanticLogger.add_appender(io: logger_stream, level: logger_level, formatter: :color)

    if container.env == :development
      SemanticLogger.add_appender(file_name: 'log/development.log')
      SemanticLogger.sync!
    end

    container.register(:logger, SemanticLogger)
  end
end
