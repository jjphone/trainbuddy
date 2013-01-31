class ProfilesController < ApplicationController
  before_filter :signed_in_user
  before_filter :auth_user
  before_filter :allow_update, only: [:update]
  before_filter :show_broadcast

  def edit
  	@profile = @user.profile
    @plans = @user.plans
  end

  def update
    if params[:search_mode].to_i <= @profile.settings.nearby
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

  def allow_update
    @profile = @user.profile
    if @profile.settings.search_mode != 2
      flash[:Error] = "Insufficient privilege"
      redirect_to(@user)
    end
  end
  
end
