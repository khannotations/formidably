Rails.application.routes.draw do
  devise_for :users

  scope '/api' do
    scope '/v1' do
      resources :batches
    end
  end
  get 'upload' => 'captricity#upload'
  get 'batch/:id' => 'captricity#get_batch'
  post 'batch' => 'captricity#create_batch'
  post '/upload_files' => 'captricity#upload_files'

  get 'dashboard' => 'main#dashboard', as: 'dashboard'
  root to: 'main#index'
end
