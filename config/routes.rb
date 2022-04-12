Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root :to => 'messages#index'

  resources :messages do
    member do
      patch :mark_as_read
    end
    collection do
      post :lost_prescription
    end
  end
end
