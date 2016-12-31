Rails.application.routes.draw do
  root to: 'timelines#index'

  devise_for :users
    resources :timelines do
      collection do
        post 'filter_by_user'
      end
    end

  if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
