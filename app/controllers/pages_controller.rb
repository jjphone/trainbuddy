
class PagesController < ApplicationController
  include Stops
  before_filter :show_broadcast

  def home
    if signed_in?
      @user = current_user
      # Rails.logger.info("---- Pages#home: params[:posts]: #{params[:posts]}")
      @posts = params[:posts]? "1"+params[:posts][1] : "11"
      if current_user.profile.settings.post < 1
        flash[:Error] = "Insufficient privilege on accessing postings."
        @feed_items = nil
      else
        @feed_items = Micropost.find_by_sql("select * from select_posts(#{current_user.id}, NULL, #{@posts[1]=='0'}, 100);").paginate(page: params[:page], per_page: 10)
      end
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
  
private
  
end
