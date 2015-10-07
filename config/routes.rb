Commenteux::Engine.routes.draw do

  get '/commenteux/:resource/:resource_id', to: 'notes#index'
  get '/commenteux/:resource/:resource_id/new', to: 'notes#new'
  post '/commenteux/:resource/:resource_id', to: 'notes#create'
  #delete '/commenteux/:resource/:resource_id', to: 'notes#destroy', defaults: { format: :js }
end
