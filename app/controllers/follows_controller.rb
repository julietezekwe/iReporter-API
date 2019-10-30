class FollowsController < ApplicationController
  def create 
    @follow = current_user.follows.find_by(following_id: params[:incident_id])
    if @follow
      @follow.destroy
      return json_response({ message: Message.unfollow_success })
    end

    @follow = current_user.follows.create!(following_id: params[:incident_id])
    response = {
      message: Message.follow_success,
      data: @follow
    }
    json_response(response, :created)
  end
end
