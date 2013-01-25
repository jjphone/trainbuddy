
class PagesController < ApplicationController
  include Stops
  before_filter :show_broadcast

  def home
    if signed_in?
      @user = current_user
#      @micropost = current_user.microposts.build

      # Rails.logger.info("---- Pages#home: params[:posts]: #{params[:posts]}")
      @posts = params[:posts]? "1"+params[:posts][1] : "11"
      @feed_items = Micropost.select_feeds(current_user.id, current_user.id, @posts).paginate(page: params[:page])
      #@stops = [1, 2, 3, 4]

       @stops =  params[:act]? find_stop_times(params[:act]) : nil
      ( Rails.logger.debug "--- PageController :: #{@stops.class} @stops = " + @stops.inspect ) if @stops
    end

  end

  def help
  end

  def about
  end

  def contact
  end
  
end
