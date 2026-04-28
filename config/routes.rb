Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  # 公開側
  root "home#show"
  resources :articles, only: %i[index show]
  resources :forms, only: [] do
    member { get :thanks }
  end

  # 管理側(認証必須)。中身は後続チケットで追加する。
  namespace :admin do
    root "dashboard#show"
    resources :visitors, only: %i[index show]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
