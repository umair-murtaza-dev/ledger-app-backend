require 'sidekiq/web'
require_relative "config/environment"

 run Sidekiq::Web
run Rails.application
