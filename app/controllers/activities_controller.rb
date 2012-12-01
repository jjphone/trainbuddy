class ActivitiesController < ApplicationController
include Stops


  def show
    respond_to do |format|
      format.html{
        dest_uri = request.referer.nil?? URI(root_url) : URI(request.referer)    
        dest_uri.query = [dest_uri.query,"act=#{params[:id]}"].compact.join('&') if params[:id]
        (Rails.logger.debug "---- dest uri :" + dest_uri.to_s) if Rails.env == "development"
        redirect_to dest_uri.to_s
      }
      format.js{
        find_stop_times(params[:id])
      }
    end

  	
  	
  	

  end


end
