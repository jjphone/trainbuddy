class UsersController < ApplicationController
  include Stops

  before_filter :signed_in_user,    only: [:index, :edit, :show, :update, :destroy]
  before_filter :auth_user,      only: [:edit, :update]
  before_filter :admin_user,        only: :destroy

  
  def index
    Rails.logger.fatal "----  index action"
    
    if params[:q] && params[:q].length > 1
      render json: find_id_name_alias(params[:q])
      
    elsif params[:commit] == "search"
      query_params = [""]
      if params[:name].size > 0
        query_params[0] =  query_params[0] + 'and users.name like ? '
        query_params.push("%#{params[:name]}%")
      end
      if params[:email].size > 0
        query_params[0] = query_params[0] + 'and users.email like ? '
        query_params.push("%#{params[:email]}%")
      end
      if params[:phone].size > 0
        query_params[0] = query_params[0] + 'and users.phone like ? '
        query_params.push("%#{params[:phone]}%")
      end
      query_params[0] = query_params[0][4...-1] # remove "and " at the 1st params str
      Rails.logger.debug "----  before User query, query_params = #{query_params.to_s}"
      @users = User.where(query_params).includes(:reverse_relationships) \
                    .where("relationships.user_id=#{current_user.id} or relationships.user_id is null") \
                    .paginate(page: params[:page], per_page: 5)
      Rails.logger.debug "----  After User query, @users.size = #{query_params.to_s}"
    else
      @user = nil
    end
  end

  def new
  	@user = User.new
  end

  def show
    if  params[:login] && params[:login].size > 0
      id_code = params[:login]
      @user = User.find_by_login(params[:login])
    else
      id_code = params[:id]
      @user = User.find_by_id(params[:id])
    end

    if @user
      @relation = Relationship.find_relation(current_user.id, @user.id)
      @users = load_other_friends(@relation)
      @post_opt = params[:posts].nil?? "11" : params[:posts]
      @feed_items = Micropost.select_feeds(current_user.id, @user.id, @post_opt)\
                        .paginate(:page => params[:page], :per_page => 10)
      @stops =  params[:act]? find_stop_times(params[:act]) : nil
      ( Rails.logger.debug "--- UserController :: #{@stops.class} @stops = " + @stops.inspect ) if @stops
    else
      flash[:Error] = "User: Could not find user with id <#{ id_code }>."
      redirect_to root_path
    end
  end


  def create
  	@user = User.new(params[:user])
  	if @user.save
  		flash[:Success] = "User was successfully created."
      sign_in @user
  		redirect_back_or(@user)
  	else
      flash[:Error] = list_errors(@user)
  		render 'new'
  	end
  end

  def edit
    @user = User.find_by_id(params[:id])
    #Rails.logger.fatal "----  edit @user.id = #{@user.id}"
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(params[:user])
      flash[:Success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      flash[:Error] = list_errors(@user)
      render 'edit'
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])
    if current_user == @user
      flash[:Error] = "Can not delete own user"
    else
      User.find(params[:id]).destroy
      flash[:Success] = "User destroy"
    end
    redirect_to users_path
  end



private
  

  def auth_user
    @user = User.find_by_id(params[:id])
    redirect_to(root_path) unless (current_user.admin? || current_user?(@user))
  end

  def find_id_name_alias(prefix)
    conditions = ActiveRecord::Base.send("sanitize_sql_array", ["(? , ?)", current_user.id, prefix ] )
    sql = "call to_json_id_name_alias" + conditions
    ActiveRecord::Base.connection.reconnect! unless ActiveRecord::Base.connection.active?
    @users = ActiveRecord::Base.connection.select_all(sql)
    return @users
  end

  def load_other_friends(relation)
    return nil if relation.nil? || relation.status != 3
    return @user.friends.paginate(:page => params[:friend_page], :per_page => 10)
    users 


  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def fetch_feed_list
    return @user.microposts.paginate(page: params[:page], per_page: 5)
  end


end
