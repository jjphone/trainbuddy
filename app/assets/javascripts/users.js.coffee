jQuery ->  
  $(document).on 'click', "a#cust-name-edit, a#custom-name-close", ->
    $("div#custom-name").slideToggle("slow", "swing")
    false


  $("input#user_login").autocomplete
    minLength: 6,
    source: $("input#user_login").data("autocomplete-source"),
    open: (e,ui) ->
      acData = $(this).data("uiAutocomplete")
      acData.menu.element.find("a").each ->
        login = $(this)
        if login.text().substr(0,15) is 'Login available'
          login.html("<span class='ok'>" +login.text()+ "</span>")
        else
          login.html("<span class='nok'>" +login.text()+ "</span>")
