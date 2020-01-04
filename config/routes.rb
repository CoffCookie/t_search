Rails.application.routes.draw do
  post "searches/search_index" => "searches#search_index"
  get "searches/search_index" => "searches#search_index"
  resources :searches

  resources :categories
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "homes#top"
end
