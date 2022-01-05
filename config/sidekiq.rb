# frozen_string_literal: true

# Code required by Sidekiq's -r argument (this file cannot have a shebang and should have an .rb extension)

require_relative '../config/application'

App.finalize!
