Rails.application.routes.draw do
  devise_for :users

  get 'dashboard' => 'captricity#dashboard', as: 'dashboard'
  get 'upload' => 'captricity#upload'
  get 'batch/:id' => 'captricity#get_batch'
  post 'batch' => 'captricity#create_batch'
  post '/upload_files' => 'captricity#upload_files'

  root to: 'main#index'
end
