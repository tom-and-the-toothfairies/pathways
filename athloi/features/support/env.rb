require 'capybara/cucumber'
require 'pathname'

Capybara.register_driver :selenium_remote_firefox do |app|
  driver = Capybara::Selenium::Driver.new(app,
                                          browser: :remote,
                                          url: 'http://selenium:4444/wd/hub',
                                          desired_capabilities: :firefox)

  driver.browser.file_detector = lambda do |args|
    str = args.first.to_s
    str if File.exist?(str)
  end

  driver
end

Capybara.configure do |config|
  config.app_host = 'http://panacea:4000'
  config.default_driver = :selenium_remote_firefox
end
