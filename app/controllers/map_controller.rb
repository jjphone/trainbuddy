class MapController < ApplicationController
  # cant use before_filter as guest should visit the page

  def index
  	if signed_in?
      show_broadcast
      sql = "select * from find_friend_locations(#{current_user.id},'#{Time.now.to_s[0...-6]}');"
#     sql = "select * from find_friend_locations(#{@user.id}, '2013-02-12 09:35')"
      res = pgsql_select_all(sql)
      @stops = Hash.new
      res.each { |r|
        @stops[ r["s_code"] ] ? @stops[r["s_code"]].push(r) : @stops.merge!( Hash[r["s_code"],[r]] ) 
      } if res
      respond_to do |format|
        format.html { @user = current_user }
        format.js
      end

  	end

  end


end
