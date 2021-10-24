Rails.application.routes.draw do
    namespace :api do
        namespace :v1 do
            resources :events, :users, :event_users
            get 'users/:id/score', to: 'users#show_score'
        end
    end
end
