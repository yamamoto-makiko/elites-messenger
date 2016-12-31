class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception 
  before_action :authenticate_user!

  # deviseのコントローラを実行する時は「configure_permitted_parameters」メソッドを実行する
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  def configure_permitted_parameters
    # 新規作成にname、thumbnail、agreementパラメータを含める
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :thumbnail, :agreement])
  end

end
