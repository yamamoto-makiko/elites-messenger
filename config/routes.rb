Rails.application.routes.draw do
  root to: 'timelines#index'



  devise_for :users
  resources :timelines do
    collection do
      post 'filter_by_user'
    end
    # 基本課題16 ADD START 
    resources :likes , only: [:create]
    # 基本課題16 ADD END
  end

  if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
