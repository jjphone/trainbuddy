module PlansHelper
  def select_for_loc(loc)
  	if loc
  	  tmp = loc.split(/2|-/)
  	  tmp.fill(nil, tmp.size...5)
  	else
  	  tmp = Array.new(5,nil)
  	end
  	tmp.map!{ |l| select(nil, nil, options_for_select(all_stations,"2#{l}"), {}, {class: "span2", id: nil} ) }
  	tmp.join
  end

end
