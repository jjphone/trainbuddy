module SessionsHelper
  def sign_in(user)
  	cookies.permanent[:remember_token] = user.remember_token
  	self.current_user = user
  end

  def current_user=(user)
  	@current_user = user
  end

  def current_user
  	@current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
  	!current_user.nil?
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, Info: "Please sign in "
    end
  end
  
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default )
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def auth_user
    @user = User.find_by_id(params[:id], include: [ {:profile => :settings}, :plans])
    if @user
        unless( current_user.admin? || current_user?(@user) )
          flash[:Error] = "Insufficient privilege"
          redirect_to @user
        end
    else
      flash[:Error] = "User with id : #{params[:id]} is not found"
      redirect_to root_path
    end
  end

end
