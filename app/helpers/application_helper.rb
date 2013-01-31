module ApplicationHelper

  def site_title(sub_title)
    sub_title.size < 1 ? "Trainbuddy" : "Trainbuddy | #{sub_title}"
  end
  

  def get_return_url(url, params)
    # add params to url due to ajax
    uri = URI(url)
    uri.query = params
    uri.to_s
  end



end
