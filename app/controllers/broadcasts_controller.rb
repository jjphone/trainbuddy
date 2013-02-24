class BroadcastsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: :destroy

  def index
  	@bc = current_user.broadcasts.paginate(page: params[:page], per_page: 10)

  end

  def destroy
  	@cast.delete
  	respond_to do |format|
  	  format.html{
  	  	flash[:Success] = "Broadcast removed"
  	  	redirect_to broadcasts_path
  	  }
  	  format.js{
  	  	flash.now[:Success] = "Broadcast removed"
  	  }
  	end
  end

private
  def correct_user
  	@cast = current_user.broadcasts.find_by_id(params[:id])
    unless @cast
      flash[:Error] = "Broadcast not exist or insufficient privilege to modify broadcast[:id = #{params[:id].to_i}]"
      redirect_to broadcasts_path
    end
  	
  end

end
