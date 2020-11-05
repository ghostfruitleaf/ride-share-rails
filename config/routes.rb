Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :drivers do
    resources :trips, only: [:show, :destroy]
  end
  resources :passengers do
    resources :trips, only: [:show, :create, :destroy]
  end
  resources :trips, only: [:index, :show, :create, :edit, :destroy]
end
