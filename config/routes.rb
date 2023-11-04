Rails.application.routes.draw do
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admins, controllers: {
    sessions: "admin/sessions"
  }
  # ユーザー用
  # URL /users/sign_in ...
  devise_for :users, controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions",
    passwords: "public/passwords"
  }

  namespace :admin do
    get '/' => 'homes#top'
    resources :users, only: [:index, :show, :edit, :update]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :posts, only: [:index, :show, :edit, :update] do
      resources :post_comments, only: [:create, :destroy]
    end
  end

  scope module: :public do
    get '/' => 'homes#top'
    get 'homes/about' => 'homes#about'
    get 'users/confirm_withdraw' => 'users#confirm_withdraw'

    resources :users, only: [:index, :show, :edit, :update]
    resources :children, only: [:index, :create, :show, :edit, :update]
    resources :posts, only: [:index,:new, :create, :show, :edit, :update, :destroy]do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
