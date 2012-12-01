module ApplicationHelper

  def site_title(sub_title)
    sub_title.size < 1 ? "Trainbuddy" : "Trainbuddy | #{sub_title}"
  end
  
  def logo
    logo = image_tag("/images/clay.jpeg", alt: "trainbuddy", class: "logo", size: "210x80" )
  end

  def remove_param(url, remove_key)
  	uri = URI(url)
  	params = Rack::Utils.parse_query(uri.query)
  	params.delete(remove_key)
  	uri.query = params.size == 0? nil : params.to_param
#  	Rails.logger.debug "---- ApplicationHelper :: remove_param -> " + uri.to_s
  	uri.to_s
  end

end
