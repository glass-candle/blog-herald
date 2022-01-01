require 'rom-factory'

ROMFactory = ROM::Factory.configure do |config|
  config.rom = App[:rom_container]
end

Dir[App.config.root.join('spec', 'support', 'factories', '*.rb')].sort.each { |file| require file }
