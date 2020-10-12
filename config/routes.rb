Rails.application.routes.draw do
  post 'surfingControll', to: 'users#surfingControll'
  post 'surfingNet', to: 'users#surfingNet'
  get 'departments', to: 'users#departments'
  resources :ddconfigs
  post 'authenticate', to: 'authentication#authenticate'
  get 'version', to: 'authentication#version'
  resources :captchas
end
