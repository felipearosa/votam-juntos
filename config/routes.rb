Rails.application.routes.draw do
  require "sidekiq/web"
  # //authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  # end

  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/comparativos', to: 'comparativos#show'
  get '/senadores', to: 'senators#show'
  get '/materias', to: 'bills#show'


end
