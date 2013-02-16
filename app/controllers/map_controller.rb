class MapController < ApplicationController
  # cant use before_filter as guest should visit the page

  def index
  	if signed_in?
  	  @user = current_user
      show_broadcast
      res = locate_friends
      @stations = Hash.new
      res.each { |r|    
        @stations[r["s_code"]] ? @stations[r["s_code"]].push(r) : @stations.merge!( Hash[r["s_code"],[r]] ) 
      }
  	end
  end



private
  def locate_friends
  	sql = "call find_friend_locations(#{@user.id}, '#{Time.now.to_s[0..-10]}')"
    #sql = "call find_friend_locations(#{@user.id}, '2013-02-14 05:29')"
  	ActiveRecord::Base.connection.reconnect! unless ActiveRecord::Base.connection.active?
    res = ActiveRecord::Base.connection.select_all(sql)
    ActiveRecord::Base.connection.reconnect!
  	return res
  end





end
