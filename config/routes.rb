Rails.application.routes.draw do
  resources :links
  resources :products do
    match '/scrape', to: 'products#scrape', via: :post, on: :collection
  end

  root to: 'products#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
