Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :restaurants do
        resources :menu_items, only: %i[index create]
      end
      resources :menu_items, only: %i[update destroy]
    end
  end
end
