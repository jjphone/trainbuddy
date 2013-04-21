	

jQuery ->
	$("#feed_menu li a, .opt_link_info a").on("click", ->
		$.getScript(this.href)
		false
	)

	$("input#quick-post-text").keyup ->
		this.value = this.value.substr(0,100) if this.value.length > 100
		$("span#quick-post-count").text( (100 - this.value.length) )

	$("li.menu-item>a").click ->
		$($(this).data('target')).collapse 'toggle'

###
	menu_hover_out(obj, delay, transit) ->
		jQuery(obj).find("i").removeClass("icon-white")
		jQuery(obj).find("ul.dropdown-menu").stop(true, true).delay(delay).fadeOut(transit)


	menu_hover_out(obj, delay, transit) ->
    	jQuery(obj).find("i").removeClass("icon-white")
    	jQuery(obj).find("ul.dropdown-menu").stop(true, true).delay(delay).fadeOut(transit)

	$("ul.nav>li.dropdown").hover =>
		 menu_hover($(this.el), 200, 300),menu_hover_out($(this.el), 100, 200) )
  	$("ul.nav>li.dropdown").hover( menu_hover($(this.el), 200, 300),menu_hover_out($(this.el), 100, 200) )
###
