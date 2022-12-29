
Rails.application.routes.draw do
  devise_for :users,
             controllers: {
                 sessions: 'users/sessions',
                 registrations: 'users/registrations'
             }
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
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
