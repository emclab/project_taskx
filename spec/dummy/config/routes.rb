Rails.application.routes.draw do


  mount ProjectTaskx::Engine => "/project_taskx"
  mount Authentify::Engine => "/authentify"
  mount Commonx::Engine => "/commonx"
  mount HeavyMachineryProjectx::Engine => '/projectx'
  mount Kustomerx::Engine => '/kustomerx'
  mount Searchx::Engine => '/searchx'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end
