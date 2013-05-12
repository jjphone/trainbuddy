jQuery ->
	$(document).on 'click', 'a#pop-accept-close, a#href-accept', =>
		$("div#pop-accept").slideToggle("slow", "swing")
		false

	$(document).on 'click', 'a#pop-request-close,a#href-request', =>
		$("div#pop-request").slideToggle("slow", "swing")
		false