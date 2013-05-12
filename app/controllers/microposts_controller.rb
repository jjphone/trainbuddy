class MicropostsController < ApplicationController

##  before_filter :signed_in_user,  only: [:create, :destroy]
  before_filter :signed_in_user
  before_filter :allowed_read, only: :index
  before_filter :allowed_write, only: [:create, :destroy]
  before_filter :correct_user,    only: :destroy 
  before_filter :show_broadcast

    MATCH_HEADER = '^!tb#'
    MSG_WEB_DONE = 28

  def new
  end

  def index

    @posts = params[:posts]? params[:posts] : "11"

    if params[:u_id]
      @url = URI(user_path(params[:u_id]))
    else
      @url = URI(feeds_path)
    end

    @url.query =  join_params( nil, @posts)

    respond_to do |format|
      format.html {  redirect_to @url.to_s  }
      format.js { 
        @user = params[:u_id] ? User.find_by_id(params[:u_id].to_i) : nil
        if @user
          sql = "select * from select_posts(#{current_user.id}, #{@user.id}, #{ @posts[1]=='0' }, 100);"
        else
          sql = "select * from select_posts(#{current_user.id}, NULL, #{ @posts[1]=='0' }, 100);"
          @user = current_user
        end
        res = pgsql_select_all(sql)
        @feed_items = Micropost.where('id in (?)', res.map{|m| m["post_id"].to_i }).paginate(page: params[:page], per_page: 10) if res
      }
    end
  end
  

  def create
    if params[:content]  =~/#{MATCH_HEADER}/i
      m=Message.create(user_id: current_user.id, status: MSG_WEB_DONE, content: params[:content] )
      Activity.do_msg(m.id, current_user.id , current_user.phone , Time.now, m.content, 8)
      # Activity.do_msg will create activity and post if required
    else
      @micropost = current_user.microposts.build(content: params[:content])
      if @micropost.save
        flash[:Success] = "Post submitted"
      else
        flash[:Error] = list_errors @micropost
      end
    end
    redirect_to root_path
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
      flash[:Error] = "Insufficient privilege on modifing the post[:id = #{params[:id].to_i}]"
      redirect_to root_url
    end
  end

  def allowed_read
    if current_user.profile.settings.post < 1
      flash[:Error] = "Insufficient privilege on accessing postings"
      redirect_to root_path
    end
  end

  def allowed_write
    if current_user.profile.settings.post < 2
      flash[:Error] = "Insufficient privilege on create or modifying postings"
      redirect_to root_path
    end     
  end

end