$("#feed_menu li a, .opt_link_info a").live("click", ->
	$.getScript(this.href)
	return false
)


$("input#quick-post-text").live("keyup",  ->
	$("div#quick-post-count").text("Chars Left: "+ (100 - this.value.length) )
)

$("input#quick-post-text").live("onchange",  ->
	this.value = this.value.substr(0,100)
)