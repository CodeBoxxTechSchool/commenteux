Commenteux::Engine.routes.draw do

  get '/commenteux/:resource/:resource_id', to: 'notes#index'
  get '/commenteux/:resource/:resource_id/new', to: 'notes#new'
  post '/commenteux/:resource/:resource_id', to: 'notes#create'

end
