# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

RspecApiDocumentation.configure do |config|
  config.format = [:html]
  config.curl_host = 'localhost'
  config.request_body_formatter = :json

end
