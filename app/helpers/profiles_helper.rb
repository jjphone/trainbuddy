module ProfilesHelper
  def options_for_search_mode(limit, selected)
  	options_for_select(
  	  ([["on the same train ONLY", 0], ["match 1 train away", 1]] + (2..limit-2).to_a.map{|k| ["match #{k} trains away", k] })[0..limit],
  	  selected)
  end
end
