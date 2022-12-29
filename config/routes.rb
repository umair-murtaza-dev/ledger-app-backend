require 'sidekiq/web'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "ledger_sidekiq_session"
# Sidekiq::Web.use(::Rack::Protection, { use: :authenticity_token, logging: true, message: "Sidekiq::Web authenticity_token Setup failed" })
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  devise_for :users,
             controllers: {
                 sessions: 'users/sessions',
                 registrations: 'users/registrations'
             }
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['ledger_sidekiq_basic_auth_username'])) &&
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['ledger_sidekiq_basic_auth_password']))
  end

  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :vendors, except: :edit
      resources :projects, except: :edit
      resources :head_of_accounts, except: :edit
      resources :expenses, except: :edit
      resources :inventory_items, except: :edit
      resources :store_locations, except: :edit
      resources :inventory_locations, except: :edit
    end
  end
end
