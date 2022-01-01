require 'database_cleaner/sequel'

RSpec.configure do |config|
  config.before(:suite, type: :integration_test) do
    DatabaseCleaner[:sequel].strategy = :truncation
  end

  config.before(:each, type: :integration_test) do
    DatabaseCleaner[:sequel].start
  end

  config.after(:each, type: :integration_test) do
    DatabaseCleaner.clean
  end
end
