jQuery ->
	$("#feed_menu li a, .opt_link_info a").on("click", ->
		$.getScript(this.href)
		false
	)

	$("input#quick-post-text").keyup ->
		this.value = this.value.substr(0,100) if this.value.length > 100
		$("span#quick-post-count").text( (100 - this.value.length) )


# pop-stops close
	$(document).on 'click', 'a#pop-stops-close', =>
		$("div#pop-stops").remove()
		false


# Header bar dropdown menu
	menu_hover = (obj, delay, transit) ->
		obj.find("i").addClass("icon-white")
		obj.find("ul.dropdown-menu").stop(true, true).delay(delay).slideDown(transit)
	
	menu_hover_out = (obj, delay, transit) ->
		obj.find("i").removeClass("icon-white")
		obj.find("ul.dropdown-menu").stop(true, true).delay(delay).fadeOut(transit)

	$("ul.nav>li.dropdown").hover(
		-> menu_hover(jQuery($(this)), 200,300),
		-> menu_hover_out(jQuery($(this)), 100,800)
	)

# leftside quick post update hide/show stations
	$("div#lmenu>div>a#quick-update-toggle").click ->
		$("div#quick-update").slideToggle("slow")
		$(this).toggleClass("btn-inverse")
		$(this).children("i").toggleClass('icon-chevron-up icon-chevron-down')



# leftside quick post reset
	$("form>div#submit>button#q_reset").click ->
		$("form>div>input#input-from").val(null)
		$("form>div>imput#input-to").val(null)

# leftside quick post submit
	$("form>div#submit>button#q_send").click ->
		if $("form>div>input#act").is(':checked')
			tb_header="!tb#syd=act"
		else
			tb_header="!tb#syd=ask"
			#alert("tb_header: " + tb_header+ " | to: " + $("form>div>input#input-from").val() )

		if ( $("form>div>input#input-from").val().length == 4 ) and ( $("form>div>input#input-to").val().length == 4 )
			content = tb_header + "#loc=" + $("form>div>input#input-from").val() + "2" + $("form>div>input#input-to").val() 

			$("form>input#content").val(content)
			#$.post("/trainbuddy/microposts", content: content  )

		else
			alert("Please enter valid from/to station names")
			return false


	remove_tag = (obj) -> 
		obj.fadeOut(2000, 'swing', => obj.delay(2000).remove() )

	# fade-in flash message
	$("div#flash_message").fadeIn(3000, ->setTimeout( (=> remove_tag($(this))  ), 20000 ) )


	# remove flash message
	$(document).on 'click', 'a#flash-message-close', =>
		remove_tag $(event.target).parent().parent()
		return false


