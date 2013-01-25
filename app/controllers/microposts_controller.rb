class MicropostsController < ApplicationController

##  before_filter :signed_in_user,  only: [:create, :destroy]
  before_filter :signed_in_user
  before_filter :correct_user,    only: :destroy 
  before_filter :show_broadcast

    MATCH_HEADER = '^!tb#'
    MSG_WEB_DONE = 28

  def new
  end

  def index
    @posts = params[:posts]? params[:posts] : "11"
    respond_to do |format|
      format.html {
        u = request.referer.nil?? URI(root_url) : URI(request.referer)
        u.query = URI(request.url).query
        Rails.logger.info("---- micropost#index: #{u.to_s}")
        redirect_to( u.to_s )
      }
      format.js { 
        user_id = params[:u_id]? params[:u_id].to_i : current_user.id
        @user = User.find_by_id(user_id)
        @user ||= current_user
        @feed_items = Micropost.select_feeds(current_user.id, @user.id, @posts).paginate(:page => params[:page])
      }
    end
  end
  
  def create
    # Rails.logger.debug "----  Micropost::create"

    if params[:content]  =~/#{MATCH_HEADER}/i
      m=Message.create(user_id: current_user.id, status: MSG_WEB_DONE, content: params[:content] )
      Activity.do_msg(m.id, current_user.id , current_user.phone , Time.now, m.content, 8)
      # Activity.do_msg will create activity and post if required
    else
      @micropost = current_user.microposts.build(content: params[:content])
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
    flash[:Success] = "Post deleted."
    redirect_to root_url
  end
  
private

  def correct_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    unless @micropost
      flash[:Error] = "Can not delete post[:id = #{params[:id].to_i}]"
      redirect_to root_url if @micropost.nil?
    end
  end

end