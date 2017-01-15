class LikesController < ApplicationController
  def create
    like = Like.new
    like.timeline_id = params[:timeline_id]
    like.user_id = current_user.id
    like.save!
    redirect_to timelines_path
  end

end