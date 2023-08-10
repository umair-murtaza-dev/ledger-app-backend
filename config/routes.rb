
Rails.application.routes.draw do
  # devise_for :users,
  #            controllers: {
  #                sessions: 'users/sessions',
  #                registrations: 'users/registrations'
  #            }
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  get 'customers/export', to: 'customers#export'
  get 'expenses/export', to: 'expenses#export'
  get 'head_of_accounts/export', to: 'head_of_accounts#export'
  get 'inventory_items/export', to: 'inventory_items#export'
  get 'inventory_locations/export', to: 'inventory_locations#export'
  get 'invoices/export', to: 'invoices#export'
  get 'projects/export', to: 'projects#export'
  get 'store_locations/export', to: 'store_locations#export'
  get 'vendors/export', to: 'vendors#export'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    devise_for :users, controllers: { sessions: :sessions },
                       path_names: { sign_in: :login }


    namespace :v1 do
      resources :vendors, except: :edit
      resources :projects, except: :edit
      resources :head_of_accounts, except: :edit
      resources :expenses, except: :edit do
        member do
          patch :upload_attachment
        end
      end
      resources :inventory_items, except: :edit
      resources :store_locations, except: :edit
      resources :inventory_locations, except: :edit
      resources :customers, except: :edit
      resources :invoices, except: :edit do
        member do
          patch :upload_attachment
        end
      end

    end
  end
  resources :users, only: [:show, :update]
end
