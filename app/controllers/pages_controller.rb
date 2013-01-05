
class PagesController < ApplicationController
  include Stops
  before_filter :show_broadcast

  def home
    if signed_in?
      @user = current_user
#      @micropost = current_user.microposts.build

      # Rails.logger.info("---- Pages#home: params[:posts]: #{params[:posts]}")
      @post_opt = params[:posts].nil?? "11" : params[:posts]
      @feed_items = Micropost.select_feeds(current_user.id, current_user.id, @post_opt).paginate(:page => params[:page], :per_page => 10)
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
