module ApplicationHelper

  def site_title(sub_title)
    sub_title.size < 1 ? "Trainbuddy" : "Trainbuddy | #{sub_title}"
  end
  
  def logo
    logo = image_tag("/images/clay.jpeg", alt: "trainbuddy", class: "logo", size: "210x80" )
  end

end
