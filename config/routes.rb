Commenteux::Engine.routes.draw do

  get '/commenteux/:resource/:resource_id', to: 'notes#index'
  get '/commenteux/:resource/:resource_id/new', to: 'notes#new'
  post '/commenteux/:resource/:resource_id', to: 'notes#create'
  get '/commenteux/:resource/:resource_id/:id/edit', to: 'notes#edit'
  patch '/commenteux/:resource/:resource_id/:id', to: 'notes#update'
  delete '/commenteux/:resource/:resource_id', to: 'notes#destroy', defaults: { format: :js }

end
