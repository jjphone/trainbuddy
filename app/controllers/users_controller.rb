class UsersController < ApplicationController
  before_filter :signed_in_user,    except: [:new, :create ]
  before_filter :allow_write,       only: [:update, :destroy]
  before_filter :auth_user,         only: [:edit, :update, :destroy]
  before_filter :show_broadcast
  
  def index
    if params[:q] && params[:q].length > 1
      
#      @users = search_users("'#{params[:q]}'", "NULL", "NULL", 10)

      @users = pgsql_select_all("select * from search_users(#{current_user.id},'#{params[:q]}',NULL,NULL, 10);")

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
    if params[:login] && params[:login].size > 0
      id_code = params[:login]
      @user = User.find_by_login(params[:login])
    else
      id_code = params[:id]
      @user = User.find_by_id(params[:id])
    end
    if @user
      @relation = Relationship.find_relation(current_user.id, @user.id)
      @users = @user.friends.paginate(:page => params[:friend_page], :per_page => 6) if current_user.has_access?(@user.id)
      @posts = params[:posts]? "2" + params[:posts][1] : "21"
      @feed_items = read_allowed_postings(@user.id, @posts)

      if params[:act]
        @stops = pgsql_select_all("select * from find_stop_times(#{current_user.id}, #{params[:act]} );")
      else
        @stops = nil
      end
    else
      flash[:Error] = "User: Could not find User[:id = #{id_code}]."
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
      flash.now[:Error] = list_errors @user
  		render 'new'
  	end
  end

  def edit

  end

  def update
    user_params = params[:user]
    if !current_user.admin? || @user.profile.settings.login < 2
      user_params["login"] = @user.login
      flash[:Error] = "Insufficient privilege on changing user login"
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
      sql = "select * from select_posts(#{@user.id}, NULL, #{ @posts[1]=='0' }, 100);"
      res = pgsql_select_all(sql)
      res ? Micropost.where('id in (?)', res.map{|m| m["post_id"].to_i }).paginate(page: params[:page], per_page: 10) : nil
    end
  end

end
