class TimelinesController < ApplicationController
  def index
    # メッセージ入力
    @input_message = params[:id] ? Timeline.find(params[:id]) : Timeline.new
    @timeline = Timeline.includes(:user).not_reply.user_filter(params[:filter_user_id]).order('updated_at DESC')
    # ユーザ一覧を取得
    @users = User.all
    if params[:reply_id]
      # 返信時は返信のタイムライン情報を取得
      @reply_timeline = Timeline.find(params[:reply_id])
    end
  end

  def create
    timeline = Timeline.new
    timeline.attributes = input_message_param
    timeline.user_id = current_user.id
    if timeline.valid? # バリデーションチェック
      timeline.save!
      #基本課題15　ADD START
      respond_to do |format|
        format.html do
          # 【ここにindexへリダイレクトさせる処理を追記】
          redirect_to action: :index
        end
        format.json do
          html = render_to_string partial: 'timelines/timeline', layout: false, formats: :html, locals: { t: timeline }
          render json: {timeline: html}
        end
      end
      #基本課題15　ADD END
    else
      #基本課題15　ADD START
      # flash[:alert] = timeline.errors.full_messages
      respond_to do |format|
        format.html do
          flash[:alert] = timeline.errors.full_messages
          # 【ここにindexへリダイレクトさせる処理を追記】
          redirect_to action: :index
        end
        format.json do
          # 【ここでエラーメッセージを渡す】
          render json: {errors: timeline.errors.full_messages}
        end
      end
      #基本課題15　ADD END
    end
    #基本課題15　DEL
    # unless request.format.json?
    #   redirect_to action: :index
    # else
    #   # ajaxの場合のレスポンス
    #   html = render_to_string partial: 'timelines/timeline', layout: false, formats: :html, locals: { t: timeline }
    #   render json: {timeline: html}
    # end
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

  def destroy
    timeline = Timeline.find(params[:id])
    timeline.destroy
    redirect_to action: :index
  end

  def filter_by_user
    if params[:filter_user_id].present?
      redirect_to action: :index, filter_user_id: params[:filter_user_id]
    else
      # フィルターなし
      redirect_to action: :index
    end
  end

  private
  def input_message_param
    params.require(:timeline).permit(:message, :reply_id)
  end
end
