class PlansController < ApplicationController
  before_filter :signed_in_user
  before_filter :check_permission, only: [:edit, :update, :destroy]
  before_filter :show_broadcast

  def new
    if current_user.plans.count < current_user.profile.settings.plans_value
      @plan = Plan.new
    else
      flash[:Error] = "Exceed the max allowed #{current_user.profile.settings.plans_value} plans allocataed for the user."
      redirect_to edit_profile_path(current_user.id)
    end
  end

  def create
    if current_user.plans.count < current_user.profile.settings.plans_value
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
      flash[:Error] = "Exceed the max allowed #{current_user.profile.settings.plans_value} plans allocataed for the user."
      redirect_to edit_profile_path(current_user.id)
    end
  end

  def edit
  	
  end

  def update
    if @plan.update_attributes(params[:plan])
      flash[:Success] = "Travel plan updated"
      redirect_to edit_profile_path(current_user.id)
    else
      flash[:Error] = list_errors(@plan)
      render 'edit'
    end
  end

  def destroy
    @plan.destroy
    redirect_to edit_profile_path(current_user.id)
  end

private

  def check_permission
    @plan = Plan.find_by_id(params[:id])
    error = true
    if @plan
      if (current_user.admin? || current_user?(@plan.user))
        error = false
      else
        flash[:Error] = "Insufficient privilege"
      end
    else
      flash[:Error] = "Plan with id #{params[:id]} is not found"
    end
    redirect_to(root_path) if error
  end

end
