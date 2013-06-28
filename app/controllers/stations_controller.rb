class StationsController < ApplicationController
  def index
  	@stations = nil
  	if params[:term] && params[:term].length > 0
  	  @stations = pgsql_select_all %Q(select * from search_stations('#{params[:term].downcase}', 5,null ); )
 # 	  render json: @stations
  	end


  	respond_to do |format|
  	  format.html { @stations = pgsql_select_all %Q(select * from station_keys;) }
  	  format.json { render json: @stations }
  	end



  end

end
