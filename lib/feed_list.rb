module Feeds
  
  # def fill_feed_lists
  #   if params[:posts]
  #     src_type = (params[:posts])[0].to_i
  #     post_type = (params[:posts])[1].to_i
  #   else
	 #   src_type = 1
	 #   post_type = 0
  #   end

  #    @feed_items = Micropost.retrieve_feed_data(@user, src_type, post_type).paginate(:page => params[:page], :per_page => 10)
  #   return @feed_items
  # end
  
  
  def find_stop_times(activity_id)
    act = Activity.find_by_id(activity_id)
    if (not act.nil?) && current_user.has_access_to(User.find_by_id(act.user_id))
      sql = "SELECT t.s_code, st.s_name, t.stop_time FROM train_time t, stations st
	      WHERE	t.line = #{act.line} AND t.train_no = '#{act.train_no}'
	      AND	t.line = st.line AND t.s_code = st.s_code
	      AND	t.s_code in ( SELECT s_code FROM stations s WHERE s.line = #{act.line} AND "
      if act.s_stop < act.e_stop
	sql += "s.s_seq >= #{act.s_stop} AND s.s_seq <= #{act.e_stop} ) ORDER BY t.stop_time"
      else
	sql += "s.s_seq >= #{act.e_stop} AND s.s_seq <= #{act.s_stop} ) ORDER BY t.stop_time"
      end
      ActiveRecord::Base.connection.reconnect! unless ActiveRecord::Base.connection.active?
      @stops = ActiveRecord::Base.connection.select_all(sql)
    else
      @stop = nil
    end
  end  


end
