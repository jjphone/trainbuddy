module UsersHelper
  def user_login_path(user, link_text=nil, css_class="")
  	link_text = user.login ? user.login : user.name unless link_text

  	link_to raw(link_text), root_path+user.to_permalink, class: css_class
  end


end
