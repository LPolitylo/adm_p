Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount MySinApp.new       => '/', as: 'my_sin'
  mount SongController.new => '/songs', as: 'my_app'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
