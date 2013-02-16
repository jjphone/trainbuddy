module MapHelper
  def gen_station_ul(code, name, align_right)
  	if @stations.has_key?(code)
      users_html = @stations[code].map { |s|
        ["<li>", link_to( [s["f_name"], "@(", s["stop_time"] ,")"].join, user_path(s["f_id"]), role:"user"), "</li>"].join
      }


res = %Q[
<ul id="#{code}" class="active" title="#{name}"><li class="dropdown#{" pull-right" if align_right}">
  <a href='#' class="dropdown-toggle" data-toggle="dropdown">#{code}</a>
  <ul class="dropdown-menu" role="menu" aria-labelledby="#{code}">
  <li>#{name}</li>
  <li class="divider"></li>                        
  #{users_html.join}
  </ul>       
</li></ul>]


  	else
      #dont care about pull-right as no popover menu
  	  res = %Q[<ul id="#{code}" title="#{name}"><li>#{code}</li></ul>]
  	end
    return res.html_safe
  end


	
end
