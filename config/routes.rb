Rails.application.routes.draw do
  resources :titles
  post '/callback' => 'linebot#callback'
end
