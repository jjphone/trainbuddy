jQuery ->
  termTemplate = "<b>%s</b>"
  $("div#quick-update>form>div.update-group>input").autocomplete
    minLength: 1,
    source: $("div#quick-update>form>div.update-group>input").data("autocomplete-source"),
    open: (e,ui) ->
      acData = $(this).data("uiAutocomplete")
      styledTerm = termTemplate.replace("%s", acData.term.toLowerCase() )
      acData.menu.element.find("a").each ->
        me = $(this)
        me.html me.text().replace(acData.term.toLowerCase(), styledTerm)





