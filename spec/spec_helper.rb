# encoding: utf-8

ENV['RACK_ENV'] = 'test'

require_relative '../main.rb'
require 'rspec'
require 'rack/test'

# Capybara settings
require 'capybara'
require 'database_cleaner'
require 'capybara/dsl'
#require 'capybara-webkit' #brew install qt
require 'capybara/poltergeist'
#Capybara.register_driver :poltergeist do |app|
#  Capybara::Poltergeist::Driver.new(app, :timeout => 60)
#end

Capybara.configure do |c|
  c.javascript_driver = :poltergeist
  c.default_driver = :poltergeist
  c.app_host = "http://localhost:4567"
end

# Needed to access Rack::Sessions
require 'rack_session_access/capybara'

Capybara.app = Sinatra::Application.new
Capybara.run_server = true
Capybara.server_port = 57124
Capybara.app_host = "http://localhost:#{Capybara.server_port}"

# brew install chromedriver
#Capybara.register_driver :chrome do |app|
#  Capybara::Selenium::Driver.new(app, :browser => :chrome)
#end

#Capybara.register_driver :webkit do |app|
#  Capybara::Driver::Webkit.new(app, :ignore_ssl_errors => true)
#end

#Capybara.javascript_driver = :webkit # :selenium, :chrome or :safari
#Capybara.current_driver = :selenium # :selenium

RSpec.configure do |config|

  # Somehow necessary for running Capybara
  config.include Capybara::DSL

  # :focus filtering for faster testing
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.include Rack::Test::Methods
end

def app
  Sinatra::Application
end
