class TimelinesController < ApplicationController
  def index
    # メッセージ入力
    #--******************** 下記を追加 *******************
    @input_message = Timeline.new
    #--***************************************************
    #--************************** 下記を追加 *********************
    # タイムラインを取得
    @timeline = Timeline.includes(:user).order('updated_at DESC')
    #--***********************************************************
  end
  #--************************** 下記を追加 *********************
  def create
    timeline = Timeline.new
    timeline.attributes = input_message_param
    timeline.user_id = current_user.id
    if timeline.valid? # バリデーションチェック
      timeline.save!
    else
      flash[:alert] = timeline.errors.full_messages
    end
    redirect_to action: :index
  end

  private
  def input_message_param
    params.require(:timeline).permit(:message)
  end
  #--***********************************************************
end
