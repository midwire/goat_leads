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
  resource :session, only: %i[new create destroy]
  resource :registration, only: %i[new create]
  resources :passwords, param: :token

  resources :faqs, only: %i[index]

  # Incoming lead endpoints
  namespace :hooks do
    resources :leads, only: %i[create]
    resources :lead_orders, only: %i[create update]
    resources :ad_daily_spend_summaries, only: %i[create]

    # HL CRM Authentication
    get 'crm_initiate', to: 'crm_oauth#initiate', as: :crm_initiate
    get 'crm_oauth', to: 'crm_oauth#oauth', as: :crm_oauth
  end

  # Agents can edit their own info
  resources :users, only: %i[edit update]
  get 'crm_cancel', to: 'crm#cancel', as: :crm_cancel
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
  resources :leads, only: %i[index show destroy edit], concerns: %i[with_datatable]

  ## Send Leads to external systems
  get 'send_lead/:service/:id', to: 'lead_distribution#send_lead', as: :send_lead

  ### DASHBOARD
  resource :dashboard, only: %i[show]

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
