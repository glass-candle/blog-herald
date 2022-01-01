# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require_relative '../config/application'

require_relative 'support/coverage'

require 'dry/system/stubs'
App.enable_stubs!
App.finalize!

require_relative 'support/vcr_config'
require_relative 'support/db_cleaner'
require_relative 'support/rom_factory'

Dir[App.config.root.join('spec', 'support', '**', '*.rb')].sort.each { |file| require file }

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.disable_monkey_patching!
  config.warnings = true
  config.order = :random

  config.after(:each) do
    App.unstub
  end
end
