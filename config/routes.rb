Rails.application.routes.draw do
  post 'examineresult', to: 'users#examine_result'
  post 'uploadexamine', to: 'users#upload_examine'
  get 'examineinfo', to: 'users#examine_info'
  post 'examine', to: 'users#examine'
  post 'surfingControll', to: 'users#surfingControll'
  post 'surfingNet', to: 'users#surfingNet'
  get 'departments', to: 'users#departments'
  resources :ddconfigs
  post 'authenticate', to: 'authentication#authenticate'
  get 'version', to: 'authentication#version'
  resources :captchas
end
