class ActivitiesController < ApplicationController
  before_filter :show_broadcast

  def show
    @params = request.query_string
    @url_prev = request.referer.nil?? URI(root_url) : URI(request.referer)    
    respond_to do |format|
      format.html{
        dest_uri = @url_prev  
        dest_uri.query = [dest_uri.query,"act=#{params[:id]}"].compact.join('&') if params[:id]
        (Rails.logger.debug "---- dest uri :" + dest_uri.to_s) if Rails.env == "development"
        redirect_to dest_uri.to_s
      }
      format.js{
        @stops = pgsql_select_all("select * from find_stop_times(#{current_user.id}, #{params[:id]} );")
        @stops = nil if @stops.size < 2
      }
    end

  	
  	
  	

  end


end
