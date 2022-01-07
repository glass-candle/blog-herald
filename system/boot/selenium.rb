# frozen_string_literal: true

App.boot(:selenium) do |container|
  init do
    require 'selenium-webdriver'

    class SeleniumAdapter
      def with_driver
        driver = begin
          options = Selenium::WebDriver::Chrome::Options.new
          ['--no-sandbox', '--disable-dev-shm-usage', '--disable-gpu'].each do |arg|
            options.add_argument(arg)
          end

          Selenium::WebDriver.for(:chrome, options: options)
        end

        yield(driver)
      ensure
        driver&.quit if defined?(driver)
      end

      def waiter(timeout = 10)
        Selenium::WebDriver::Wait.new(timeout: timeout)
      end
    end

    container.register(:selenium_adapter) { SeleniumAdapter.new }
  end
end
