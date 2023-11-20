Rails.application.routes.draw do

  devise_for :admins, controllers: {
    sessions: "admin/sessions"
  }

  devise_for :users, controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  namespace :admin do
    root to: 'homes#top'
    resources :users, only: [:index, :edit, :update]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :posts, only: [:index, :edit, :update] do
      resources :post_comments, only: [:create, :destroy, :update]
    end
    resources :tags, only: [:index]
  end

  scope module: :public do
    root to: 'homes#top'
    get 'users/confirm_withdraw' => 'users#confirm_withdraw', as: 'confirm_withdraw'
    patch 'users/:id/withdraw' => 'users#withdraw', as: 'withdraw'
    get '/post/hashtag/:name' => 'posts#hashtag', as: 'hashtag'
    get 'search' => 'searches#search'
    get 'genre_search' => 'searches#genre_search'

    resources :users, only: [:index, :show, :edit, :update] do
      member do
        get :followings, :followers
      end
      resource :user_relationships, only: [:create, :destroy]
      end
    resources :children, only: [:index, :create, :show, :edit, :update]
    resources :posts, only: [:index,:new, :create, :show, :edit, :update, :destroy] do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    resources :inform_activities, only: [:index] do
      collection do
        delete :destroy_all
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
