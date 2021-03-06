class RelationshipsController < ApplicationController
	before_filter :signed_in_user
  before_filter :allow_read, only: [:index]
  before_filter :allow_write, only: [:updates]
  before_filter :show_broadcast

  def index
    # type = params[:type]? params[:type] : "friends"
    # condit = load_condit(type)
    condit = load_condit(params[:type])

    @users = User.where("users.id in (#{condit})",{user: current_user.id})\
                  .includes(:reverse_relationships) \
                  .where("relationships.user_id=#{current_user.id} or relationships.user_id is null")\
                  .paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def updates
  	@user = find_other(params[:other])
  	has_error = false


  	if @user
  		case params[:op].to_i
  		when -1
  			Relationship.block(current_user.id, @user.id)
  			flash.now[:Success] = "User blocked"
  		when 0
  			Relationship.unfriend(current_user.id, @user.id)
  			flash.now[:Success] = "User removed from Friends"
  		when 1
  		  Relationship.request(current_user.id, @user.id)
        friend_request_mail(current_user, @user, params[:msg])
  		when 3 
  			Relationship.accept(current_user.id, @user.id, params[:nick])
  			flash.now[:Success] = "User added into friend list"
      when 5
        Relationship.set_alias(current_user.id, @user.id, params[:nick] )
        flash.now[:Success] = "Alias name updated"
  		else
  			has_error = true
  			flash.now[:Error] = "Unknow operation code"
  		end
      @url = URI(user_path(@user.id))
      @url.query = join_params(nil, @posts)
  	else
      flash.now[:Error] = "Can not find user with :id #{params[:other]}"
  		has_error = true
  	end

  	if has_error
  		redirect_to(root_path)
  	else
      @relation = Relationship.find_relation(current_user.id, @user.id)
  		respond_to do |format|
  			format.html { redirect_to @user }
  		 	format.js
  		end
  	end
  end


private
  def find_other(user_id)
  	res = User.find_by_id(user_id)
  	if res.nil?
  		flash[:Error] = "Can not find User with id (#{user_id.to_i})"
  		return nil
  	end
  	if current_user?(res)
  		flash[:Error] = "Can not create relationship with own"
  		return nil
  	end
  	return res
  end

  def load_condit(type)
    case type
    when "block"
      @title = "Blocked users"
      condit = %(select friend_id from relationships where status = -1 and user_id = :user)
    when "request"
      @title = "Requests"
      condit = %(select friend_id from relationships where status = 1 and user_id = :user)
    when "pending"
      @title = "Pending Confirmation"
      condit = %(select friend_id from relationships where status = 2 and user_id = :user)
    when "suggest"
      @title =  "Suggest Friends"
      condit = %(select a.friend_id from relationships f, relationships a 
                  where f.user_id = :user and f.status = 3
                  and   a.friend_id <> :user and a.status = 3
                  and   a.friend_id not in 
                  ( select friend_id from relationships where status = 3 and user_id = :user)
                  and f.friend_id = a.user_id
                )
    else
      @title = "Friends"
      condit = %(select friend_id from relationships where status = 3 and user_id = :user)
    end
  end

  def allow_read
    if current_user.profile.settings.friends < 1
      flash[:Error] = "Insufficient privilege on accessing user relationships"
      redirect_to root_path
    end
  end

  def allow_write
    if current_user.profile.settings.friends < 2
      flash[:Error] = "Insufficient privilege on create or modifying user relationships"
      redirect_to root_path
    end
  end


end

