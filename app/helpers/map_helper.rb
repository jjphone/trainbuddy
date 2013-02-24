module MapHelper

  def gen_owner_class(pos)
    res = pos>2? "own down" : "own up"
    res = res + " pull-right" if pos.even?
    return res
  end

  def gen_friends_class(pos)
    res = pos.even?? "dropdown down pull-right" : "dropdown down"
  end

  def other_stations(exclude_stations)
    s = Activity.station_pairs
    exclude_stations.each { |k| s.delete k }
    return s
  end
	
end
