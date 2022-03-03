Rails.application.routes.draw do
  get 'tracking_requests', to: 'tenants#index'
  get 'welcome/index'
  root 'welcome#index'

  namespace 'api' do
    namespace 'v1' do
      resources :questions
    end
  end
end
