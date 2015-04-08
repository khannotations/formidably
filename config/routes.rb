Rails.application.routes.draw do
  root 'captricity#batches'

  get 'batch/:id' => 'captricity#batch'
  post 'batch/:id/upload' => 'captricity#upload'
end
