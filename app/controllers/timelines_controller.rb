class TimelinesController < ApplicationController
  def index
    # メッセージ入力
    #--******************** 下記を追加 *******************
    # @input_message = Timeline.new
    # メッセージ入力
    @input_message = params[:id] ? Timeline.find(params[:id]) : Timeline.new
    #--***************************************************
    #--************************** 下記を追加 *********************
    # タイムラインを取得
    # @timeline = Timeline.includes(:user).order('updated_at DESC')
    # @timeline = Timeline.includes(:user).user_filter(params[:filter_user_id]).order('updated_at DESC')
    #--********************* 修正後 *****************
    @timeline = Timeline.includes(:user).not_reply.user_filter(params[:filter_user_id]).order('updated_at DESC')
    #--******************** 下記を追加 **********************
    # ユーザ一覧を取得
    @users = User.all
    #--******************************************************
    #--********************** 下記を追加 *********************
    if params[:reply_id]
      # 返信時は返信のタイムライン情報を取得
      @reply_timeline = Timeline.find(params[:reply_id])
    end
    #--******************************************************
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
    # redirect_to action: :index
    unless request.format.json?
      redirect_to action: :index
    else
      # ajaxの場合のレスポンス
      html = render_to_string partial: 'timelines/timeline', layout: false, formats: :html, locals: { t: timeline }
      render json: {timeline: html}
    end
  end

  def update
    timeline = Timeline.find(params[:id])
    timeline.attributes = input_message_param
    if timeline.valid? # バリデーションチェック
      timeline.save!
    else
      flash[:alert] = timeline.errors.full_messages
    end
    redirect_to action: :index
  end
#--********************** 下記を追加 *************************
  def destroy
    timeline = Timeline.find(params[:id])
    timeline.destroy
    redirect_to action: :index
  end
#--**********************************************************
#--************************ 下記を追加 *********************
  def filter_by_user
    if params[:filter_user_id].present?
      redirect_to action: :index, filter_user_id: params[:filter_user_id]
    else
      # フィルターなし
      redirect_to action: :index
    end
  end
#--*********************************************************

  private
  def input_message_param
    # params.require(:timeline).permit(:message)
    # --*************** , :reply_idを追加 ********-->
    params.require(:timeline).permit(:message, :reply_id)
  end
  #--***********************************************************
end
