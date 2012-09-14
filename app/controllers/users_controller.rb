class UsersController < ApplicationController
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
  		redirect_to (@user)
  	else
  		error_msg = "Form contains #{ @user.errors.count} error(s). <br/><ul>"
  		@user.errors.full_messages.each { |m| error_msg += "<li> #{ m } </li>" }
      error_msg += "</ul>"
  		flash[:Error] = error_msg
  		render 'new'
  	end
  end


end
