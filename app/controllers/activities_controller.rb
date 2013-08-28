class ActivitiesController < ApplicationController
  before_filter :show_broadcast

  def show
    @url = params[:u_id] ? URI(user_path(params[:u_id].to_i)) : URI(feeds_path)
    @url.query =  join_params(nil, @posts)
    respond_to do  |format|
      format.html{ 
        dest_uri = URI( @url.to_s )
        dest_uri.query =  dest_uri ? dest_uri.query.to_s + "&act=#{params[:id].to_i}" : "act=#{params[:id].to_i}"
        Rails.logger.debug ["---- dest_uri : ", dest_uri.to_s, "  @url", @url.to_s].join if Rails.env == "development"
        redirect_to dest_uri.to_s
      }
      format.js {
        @stops = pgsql_select_all("select * from find_stop_times(#{current_user.id}, #{params[:id]} );")
      }
    end
  end


end
