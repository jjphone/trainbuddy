class PagesController < ApplicationController
	
  def home
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feeds.paginate(page: params[:page], per_page: 5)
    end


  end

  def help
  end

  def about
  end

  def contact
  end
  
end
