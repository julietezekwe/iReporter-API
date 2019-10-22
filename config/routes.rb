Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'signup', to: 'reporters#create'
  post 'login', to: 'authentication#authenticate'

  get 'search', to: 'incidents#search'
  resources :incidents do
    resources :follows, only: [:create, :index]
    resources :comments, except: [:show] do
      resources :comment_replies, except: [:show, :index]
    end
  end
end
