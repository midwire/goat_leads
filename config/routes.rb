# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq_unique_jobs/web'

Rails.application.routes.draw do
  # Datatable route
  concern :with_datatable do
    post 'datatable', on: :collection
  end

  # Welcome routes, non-authenticated
  get 'welcome/index'
  get 'welcome/terms'
  get 'welcome/privacy'
  root 'welcome#index'

  # auth routes
  resource :session
  resource :registration, only: %i[new create]
  resources :passwords, param: :token

  resources :faqs, only: %i[index]

  # Incoming lead endpoints
  namespace :hooks do
    resources :leads, only: %i[create]
    resources :lead_orders, only: %i[create]
  end

  # Agents can edit their own info
  resources :users, only: %i[edit update]
  resources :email_verifications, only: %i[show new], param: :token do
    collection do
      post :resend
    end
  end
  resources :lead_orders, concerns: %i[with_datatable] do
    member do
      patch :cancel
    end
  end
  resources :leads, only: %i[index show destroy], concerns: %i[with_datatable]

  # Admin Interfaces
  namespace :admin do
    resources :users, concerns: %i[with_datatable]
    resource :form_config, only: %i[show]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Mount sidekiq interface
  mount Sidekiq::Web, at: '/sidekiq', constraints: AdminConstraint
end
