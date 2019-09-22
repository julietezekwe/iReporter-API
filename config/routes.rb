Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'signup', to: 'reporters#create'
  post 'login', to: 'authentication#authenticate'

  resources :incidents
end
