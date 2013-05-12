
class PagesController < ApplicationController

  before_filter :show_broadcast

  def home
    if signed_in?
      @user = current_user

      @posts = params[:posts]? "1"+params[:posts][1] : "11"
      if current_user.profile.settings.post < 1
        flash[:Error] = "Insufficient privilege on accessing postings."
        @feed_items = nil
      else
        sql = "select * from select_posts(#{current_user.id}, NULL, #{ @posts[1]=='0' }, 100);"
        res = pgsql_select_all(sql)
        @feed_items = Micropost.where('id in (?)', res.map{|m| m["post_id"].to_i }).paginate(page: params[:page], per_page: 10) if res
      end

      if params[:act]
        @stops = pgsql_select_all("select * from find_stop_times(#{current_user.id}, #{params[:act]} );")
        ( Rails.logger.debug "--- PageController :: #{@stops.class} @stops = " + @stops.inspect ) if @stops
      else
        @stops = nil
      end 
      @url = URI(feeds_path)
      @url.query = join_params(nil, @posts)
      Rails.logger.debug ['---- PagesController#index :: @url = ', @url.to_s ].join
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
