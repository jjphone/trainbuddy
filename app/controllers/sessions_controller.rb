class SessionsController < ApplicationController
  def new

  end

  def create
  	if user = login( params[:session][:email], params[:session][:password] )
  		redirect_back_or root_url
  	else
  		render 'new'
  	end
  end

  def destroy
  	sign_out
  	redirect_to root_url
  end

private
	def login(email, password)
		if (email.size < 6 || password.size <6)
			flash.now[:Error] = "Miniumn 5 characters is required"
			return false
		end
		user = User.find_by_email(email.downcase)
		if user && user.authenticate(password)
			sign_in user
			return user
		else
			flash.now[:Error] = "Invalid email/password combinations. "
			return false
		end
	end

end
