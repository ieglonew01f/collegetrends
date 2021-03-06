class FollowersController < ApplicationController

  def create
    follower = Follower.new(follower_params)
    follower.follower_id = current_user.id
    follower.following_id = params[:follower][:following_id]

    respond_to do |format|
      if follower.save
        format.json { render :json => { :status => 200, :message => 'Follow success', :follower => follower } }
      else
        format.json { render json => { :status => :unprocessable_entity, :errors => follower.errors } }
      end
    end
  end

  def destroy
    follower = Follower.where('follower_id = ? AND following_id = ?', current_user.id, params[:follower][:following_id]).first

    respond_to do |format|
      if follower.delete
        format.json { render :json => { :status => 200, :message => 'Unfollow success', :follower => follower} }
      else
        format.json { render json => { :status => :unprocessable_entity, :errors => post.errors } }
      end
    end
  end

  def get_following
    followings = Follower.where('follower_id = ?', current_user.id).all

    followings_data = []

    if followings
      followings.each do |f|
        if f && f.following_id
          user = User.find(f.following_id)
          if user
            followings_data.push(user)
          end
        end
      end
    end

    respond_to do |format|
      if followings
        format.json { render :json => { :status => 200, :message => 'Followings', :followings_data => followings_data} }
      else
        format.json { render json => { :status => :unprocessable_entity, :errors => post.errors } }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def follower_params
      params.require(:follower).permit(:following_id)
    end
end
