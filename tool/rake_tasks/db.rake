require 'rom/sql'
require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    App.start(:persistence)
    ROM::SQL::RakeSupport.env = App[:rom_container]
  end
end
