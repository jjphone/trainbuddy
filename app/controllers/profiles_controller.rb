class ProfilesController < ApplicationController
  before_filter :signed_in_user
  before_filter :auth_user
  before_filter :show_broadcast

  def edit
  	@profile = @user.profile
    @plans = @user.plans
  end

  def update
  	@profile = @user.profile
  	if @profile.settings.search_mode == 2 && (params[:search_mode].to_i <= @profile.settings.nearby)
  	  @profile.transaction do
  	  	@profile.search_mode = params[:search_mode].to_i
        @profile.notify_users = [@profile.settings.notify_users, params[:notify_users].to_i ].min
  	  	if @profile.save
  	  	  flash[:Success] = "User search mode updated."
  	  	else
  	  	  flash[:Error] = "Unable to update user profile. Try again later."
  	  	end
  	  end
  	else
  	  flash[:Error] = "Exceed the allocated limit by this user level"
  	end
  	redirect_to edit_profile_path(@profile)
  end

private
  def auth_user
    error = false
    @user = User.find_by_id(params[:id], include: [ {:profile => :settings}, :plans])
    if @user.nil?
      flash[:Error] = "User with id : #{params[:id]} is not found"
      error = true
    end
    unless ( current_user.admin? || current_user?(@user) )
      flash[:Error] = "Insufficient privilege"
      error = true
    end
    redirect_to(root_path) if error
  end
end
