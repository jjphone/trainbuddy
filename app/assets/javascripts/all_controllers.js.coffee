	

jQuery ->
	$(".menu-body").addClass("collapse")

	$("#feed_menu li a, .opt_link_info a").live("click", ->
		$.getScript(this.href)
		false
	)

	$("input#quick-post-text").keyup ->
		this.value = this.value.substr(0,100) if this.value.length > 100
		$("span#quick-post-count").text( (100 - this.value.length) )

	$("li.menu-item>a").click ->
		$($(this).data('target')).collapse 'toggle'

	$("a#flash-message-close").click ->
		$("div#flash-message").remove()
		false
