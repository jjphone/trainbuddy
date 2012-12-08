class MicropostsController < ApplicationController

  before_filter :signed_in_user,  only: [:create, :destroy]
  before_filter :correct_user,    only: :destroy 

    MATCH_HEADER = '^#tb@'
    MSG_WEB_DONE = 28


  def index
    
    respond_to do |format|
      format.html {
        u = request.referer.nil?? URI(root_url) : URI(request.referer)
        u.query = URI(request.url).query
        Rails.logger.info("---- micropost#index: #{u.to_s}")
        redirect_to( u.to_s )
      }
      format.js { 
        
        @post_opt = params[:posts].nil?? "11" : params[:posts]
        user_id = params[:u_id].nil?? current_user.id : params[:u_id].to_i
        @user = User.find_by_id(user_id)
        @feed_items = Micropost.select_feeds(current_user.id, user_id, @post_opt).paginate(:page => params[:page], :per_page => 10)
      }
    end
  end
  
  def create
  	@micropost = current_user.microposts.build(params[:micropost])

    if @micropost.content=~/#{MATCH_HEADER}/i
      m=Message.create(user_id: current_user.id, status: MSG_WEB_DONE, content: @micropost.content )
      Rails.logger.debug("MicropostsController::create:: do_msg(#{m.id}, #{current_user.id} , #{current_user.phone} , #{Time.now}, #{@micropost.content}, 8)" )
      Activity.do_msg(m.id, current_user.id , current_user.phone , Time.now, @micropost.content, 8)
      # Activity.do_msg will create activity and post if required
    else
      if @micropost.save
        flash[:Success] = "Post submitted"
      else
        flash[:Error] = list_errors(@micropost)
      end
    end







    redirect_to root_url
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end
  
private

  def correct_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_url if @micropost.nil?
  end

end