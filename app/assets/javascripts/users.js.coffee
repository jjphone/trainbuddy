  
$(document).on 'click', "a#cust-name-edit, a#custom-name-close", ->
  $("div#custom-name").slideToggle("slow", "swing")
  false
