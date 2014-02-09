BetSettler::Application.routes.draw do
  resources :bets do
    member do
      get '/close', to: 'bets#close', as: 'close'
      post '/close', to: 'bets#close_2', as: 'close_2'
      get '/stats', to: "bets#stats", as: 'stats'
    end
    resources :positions
    resources :invitations
  end
  
  devise_for :users
  get '/help', to: 'site#help', as: 'help'
  root "site#index"
end
