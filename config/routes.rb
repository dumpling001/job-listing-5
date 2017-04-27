Rails.application.routes.draw do
  devise_for :users

  resources :jobs do
    member do
      post :inbox
      post :outbox
      post :ilike
      post :unlike
    end
    resources :resumes
    collection do
      get :search
    end
  end

  namespace :admin do
    resources :jobs do
      member do
        post :publish
        post :hide
      end
      resources :resumes
    end
  end

  namespace :account do
    resources :jobs
  end

  root 'welcome#index'
end
