$ ->

  $("#nav > li > a.collapsed + ul").slideToggle("medium")
  
  $("#nav > li > a").click ->
    $(this).toggleClass('expanded').toggleClass('collapsed').parent().find('> ul').slideToggle('medium')
