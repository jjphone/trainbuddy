class ProfilesController < ApplicationController
  before_filter :signed_in_user
  before_filter :auth_user
  before_filter :show_broadcast

  def edit
  	@profile = @user.ext_setting
  end

  def update
  	@profile = @user.ext_setting
  	if params[:search_mode].to_i <= @profile.settings.nearby
  	  @profile.transaction do
  	  	@profile.search_mode = params[:search_mode].to_i
  	  	if @profile.save
  	  	  flash[:Success] = "User search mode updated."
  	  	else
  	  	  flash[:Error] = "Unable to update user profile. Try again later."
  	  	end
  	  end
  	else
  	  flash[:Error] = "Exceed the allocated limit(#{@profile.nearby}) by user level"
  	end
  	redirect_to edit_profile_path(@profile)
  end

private
  def auth_user
    @user = User.find_by_id(params[:id])
    redirect_to(root_path) unless (current_user.admin? || current_user?(@user))
  end
end
