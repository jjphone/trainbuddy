class UsersController < ApplicationController
  before_filter :signed_in_user,    except: [:new, :create ]
  before_filter :allow_write,       only: [:update, :destroy]
  before_filter :auth_user,         only: [:edit, :update, :destroy]
  before_filter :show_broadcast
  
  def index




    if params[:q] && params[:q].length > 1
      # tokeninput - mod=mail
      @users = pgsql_select_all("select * from search_users(#{current_user.id},'#{params[:q]}',NULL,NULL, 10);")
      render json: @users
      
    elsif params[:term] && params[:term].length > 1
      # autocomplete = mod=login
      #@users = pgsql_select_all("select * from login_available('#{params[:term].downcase}');")
      
      if params[:term].length < 6 || params[:term].length > 18
        @users = [{value: '', label: 'NOT Available - length between 6 to 18 chars long'}]
      elsif params[:term] =~ /^[a-z][a-z0-9]*(_|\.){1}[a-z0-9]+$/i
        @users = pgsql_select_all("select * from login_available('#{params[:term].downcase}');")
      else
        @users = [{value: '', label: 'NOT Available - Only allow (a-z,0-9) with (. or _) once within the login'}]
      end
      render json: @users

    elsif params[:commit] == "Find"
      if (params[:name].size>1 || params[:email].size>1 || params[:phone].size>1)
        name = params[:name].size>0 ? "'#{params[:name]}'" : "NULL"
        email = params[:email].size>0 ? "'#{params[:email]}'" : "NULL"
        phone = params[:phone].size>0 ? "'#{params[:phone]}'" : "NULL"

        res = pgsql_select_all("select * from search_users(#{current_user.id},#{name},#{phone},#{email}, 100);")

#     not sure if best to include eager loading. can't limit relationships.user_id = current_user
#     @user = User.include(:reverse_relationships).where(["User.id in (?)", res.map{|u| u["id"].to_i}])

        @users = User.where(['id in (?)', res.map{|u| u["id"].to_i } ]).paginate(page: params[:page], per_page: 5) if res
      else
        flash.now[:Error] = "Search text required at least 2 characters"
        @users = nil
      end

    else
      @users = nil
    end
  end


  def new
  	@user = User.new
  end

  def show
    error_msg = fetch_user

    if @user
      @relation = Relationship.find_relation(current_user.id, @user.id)
      @users = @user.friends.paginate(:page => params[:friend_page], :per_page => 6) if current_user.has_access?(@user.id)
      @posts = params[:posts]? "2" + params[:posts][1] : "21"
      @feed_items = read_allowed_postings(@user.id, @posts)
      @stop = params[:act]? pgsql_select_all("select * from find_stop_times(#{current_user.id}, #{params[:act]} );") : nil

      @url = URI(user_path(@user.id))
      @url.query = join_params(nil, @posts)
      Rails.logger.debug ['---- UserController#index :: @url = ', @url.to_s ].join
    else
      flash[:Error] = error_msg
      redirect_to root_path
    end
  end


  def create
  	@user = User.new(params[:user])
    @user.login = @user.login.downcase
  	if @user.save
  		flash[:Success] = "User was successfully created."
      sign_in @user
  		redirect_back_or(@user)
  	else
      flash.now[:Error] = list_errors @user
  		render 'new'
  	end
  end

  def edit

  end

  def update
    user_params = params[:user]
    


    if user_params[:login] && @user.login
      if @user.profile.settings.login < 2 || !current_user.admin? 
        user_params[:login] = @user.login
        flash[:Error] = "Insufficient privilege on changing user login - reset to default"
      else
        user_params[:login] = user_params[:login].downcase
      end
    end

    if @user.update_attributes(user_params)
      flash[:Success] = "User info updated"
      sign_in @user
      redirect_to @user
    else
      flash.now[:Error] = list_errors(@user)
      render 'edit'
    end
  end

  def destroy
    if current_user?(@user)
      flash[:Error] = "Can not delete own user"
    else
      @user.destroy
      flash[:Success] = "User #{@user.id} destroy"
    end
    redirect_to users_path
  end



private

  def fetch_user
    if params[:login] && params[:login].size > 5
      id_code = params[:login]
      @user = User.find_by_login(params[:login])
      error_msg =  @user ? nil : "User: Could not find User[ login = #{params[:login]} ]" 
    else
      id_code = params[:id]
      @user = User.find_by_id(params[:id])
      error_msg =  @user ? nil : "User: Could not find User[ id = #{params[:id]} ]" 
    end
    return error_msg
  end


  def allow_write
    if current_user.profile.settings.password < 2
      flash[:Error] = "Insufficient privilege on modifying user info"
      redirect_to root_path
    end
  end

  def read_allowed_postings(user_id, posts)
    if current_user.profile.settings.post < 1
      flash[:Error] = "Insufficient user privilege on accessing postings."
      return nil
    else
      sql = "select * from select_posts( #{current_user.id}, #{@user.id}, #{ posts[1]=='0' }, 100);"
      res = pgsql_select_all(sql)
      res ? Micropost.where('id in (?)', res.map{|m| m["post_id"].to_i }).paginate(page: params[:page], per_page: 10) : nil
    end
  end

end
