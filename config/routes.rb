Rails.application.routes.draw do
  resources :signal_lamps
  resources :cameras
  resources :devices
  resources :users
  resources :examples do
    collection do
      get :download
      post :upload
      post :uploadmore
    end
  end
  delete 'examples/:id/image', to: 'examples#image'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'authenticate', to: 'authentication#authenticate'
  get 'authenticate', to: 'authentication#version'
  resources :captchas
end
