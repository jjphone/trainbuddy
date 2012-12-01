$("#feed_menu li a, .opt_link_info a").live("click", ->
	$.getScript(this.href)
	return false
)


$("#post_text").live("keyup",  ->
	this.value = this.value.substr(0,100)
	$("#textAreaCount").text("Chars Left: "+ (100 - this.value.length) )
)