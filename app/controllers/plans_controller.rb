class PlansController < ApplicationController
  before_filter :signed_in_user
  before_filter :auth_user, only: [:edit, :update, :destroy]
  before_filter :show_broadcast

  def new
    @plan = Plan.new(user_id: current_user)
  end

  def create
    if current_user.plans.size < current_user.profile.settings.plans_value
      @plan = current_user.plans.new(params[:plan])
      @plan.name = @plan.name.downcase
      if @plan.save
        flash[:Success] = "New travel plan created"
        redirect_to edit_profile_path(current_user.id)
      else
        flash[:Error] = list_errors(@plan)
        render 'new'
      end
    else
      flash[:Error] = "Exceed the allocated limit by this user level"
      redirect_to edit_profile_path(current_user.id)
    end
  end

  def edit
  	
  end

  def update
    if @plan.update_attributes(params[:plan])
      flash[:Success] = "Travel plan updated"
      redirect_to edit_profile_path(@plan.user_id)
    else
      flash[:Error] = list_errors(@plan)
      render 'edit'
    end
  end

  def destroy
    @user = @plan.user_id

    @plan.destroy
    redirect_to edit_profile_path(@user)
  end

private

  def auth_user
  	error = false
    @plan = Plan.find_by_id(params[:id])
    if @plan.nil?
      flash[:Error] = "Plan with id #{params[:id]} is not found"
      error = true
    end
    unless (current_user.admin? || current_user?(@plan.user))
      flash[:Error] = "Insufficient privilege"
      error = true
    end
    redirect_to(root_path) if error
  end

end
