require 'rom/sql'
require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    App.init(:persistence)
    ROM::SQL::RakeSupport.env = App[:rom_config]
  end
end
