class StationsController < ApplicationController
  def index
  	@stations = pgsql_select_all %Q(select * from search_stations('#{params[:term].downcase}', 5,null ); )
  	#render json: @stations.map{ |n| n["display"]}
  	render json: @stations
  end

end
