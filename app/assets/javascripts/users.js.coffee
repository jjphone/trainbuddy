# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# open Left Menu <Friends> menu in Users controller
$("a#friend").toggleClass('expanded').toggleClass('collapsed').parent().find('> ul').slideToggle('fast')
