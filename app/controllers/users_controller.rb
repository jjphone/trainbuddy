class UsersController < ApplicationController
  before_filter :signed_in_user,    only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,      only: [:edit, :update]
  before_filter :admin_user,        only: :destroy

  def index

    # if params[:q] && params[:q].size > 1
    #   render json: find_id_name_alias(params[:q])
    # end

    Rails.logger.fatal "----  index action"

    if params[:commit] == "search"
      query_params = [""]
      if params[:name].size > 0
        query_params[0] =  query_params[0] + 'and name like ? '
        query_params.push("%#{params[:name]}%")
      end
      if params[:email].size > 0
        query_params[0] = query_params[0] + 'and email like ? '
        query_params.push("%#{params[:email]}%")
      end
      if params[:phone].size > 0
        query_params[0] = query_params[0] + 'and phone like ? '
        query_params.push("%#{params[:phone]}%")
      end
      query_params[0] = query_params[0][4...-1] # remove "and " at the 1st params str
      Rails.logger.fatal "----  before User query, query_params = #{query_params.to_s}"
      @users = User.where(query_params).paginate(page: params[:page], per_page: 10)
      
      Rails.logger.fatal "----  After User query, @users.size = #{query_params.to_s}"

    else
      @user = nil
    end

  end



  def new
  	@user = User.new
  end

  def show
  	id_code = params[:id]
  	@user = id_code=~/^\d+/ ? User.find_by_id(id_code[/^\d+/]) : User.find_by_login(id_code)
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
  def list_errors(err_obj)
    error_msg = ""
    err_obj.errors.full_messages.each { |m| error_msg += "<li>#{m}</li>" }
    error_msg = "Form contains #{err_obj.errors.count} error(s). <br><ul> #{error_msg} </ul>"
    return error_msg
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, Info: "Please sign in "
    end
  end

  def correct_user
    @user = User.find_by_id(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def find_id_name_alias(prefix)
    condition = ActiveRecord::Base.send("sanitize_sql_array", ["(? , ?)", current_user.id, prefix ] )
    sql = "call to_json_id_name_alias" + conditions
    ActiveRecord::Base.connection.reconnect! unless ActiveRecord::Base.connection.active?
    @users = ActiveRecord::Base.connection.select_all(sql)
    return @users
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end
