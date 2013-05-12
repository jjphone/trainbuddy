	

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

	$(document).on 'click', 'a#pop-stops-close', =>
		$("div#pop-stops").remove()
		false

	$(document).on 'click', 'a#flash-message-close', =>
		$("div#flash-message").fadeToggle("slow", "swing", ->
			$("div#flash-message").delay(3000).remove()
		)
		false

	menu_hover = (obj, delay, transit) ->
		obj.find("i").addClass("icon-white")
		obj.find("ul.dropdown-menu").stop(true, true).delay(delay).slideDown(transit)
	
	menu_hover_out = (obj, delay, transit) ->
		obj.find("i").removeClass("icon-white")
		obj.find("ul.dropdown-menu").stop(true, true).delay(delay).fadeOut(transit)

	$("ul.nav>li.dropdown").hover(
		-> menu_hover(jQuery(@), 200,300),
		-> menu_hover_out(jQuery(@), 100,200)
	)
