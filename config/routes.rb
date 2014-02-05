BetSettler::Application.routes.draw do
  resources :bets do
    resources :positions
  end
  
  devise_for :users
  get '/help', to: 'site#help', as: 'help'

  root "site#index"
end
