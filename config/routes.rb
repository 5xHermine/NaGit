Rails.application.routes.draw do
  devise_for :users, path: '', 
                     path_names: { 
                        sessions: "sessions", 
                        sign_up: 'register', 
                        sign_in: 'login', 
                        sign_out: 'logout'
                     }
  root "home#index"
  get ':user_name', to: "home#logged_in", as: "logged_in"

  scope '/:user_name' do
    resources :relationships, only: [:index, :create, :destroy]
    get "relationships/followers", to: "relationships#followers", as: "followers"
    resources :likes, only: [:index]
    get "repository/:id/branches", to: "repositories#branches", as: "branches"
    get "repository/:id/commits", to: "repositories#commits", as: "commits"
    get "repository/:id/contributors", to: "repositories#contributors", as: "contributors"
    get "repository/:id/checkout", to: "repositories#checkout", as: "checkout"
    get "repository/:id/branch/diff", to: "repositories#branch_diff", as: "branch_diff"
    get "repository/:id/commit/diff", to: "repositories#commit_diff", as: "commit_diff"
    resources :repositories do
      resources :likes, only: [:create, :destroy]
      resources :pull_requests do
        resources :comments, only:[:create, :update, :destroy]
      end
      resources :issues do
        resources :comments, only:[:create, :update, :destroy]
        member do
          get :toggle_status
        end
      end
    end
  end
  get "/:user_name/repositories/:id/worktree/master/*file", to: "repositories#show" 

end
