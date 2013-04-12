# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  l = window.location
  users_index_url = l.protocol + '//' + l.host + '/' + l.pathname.split('/')[1]+'/users'
  
  $('input#mail_to_users').tokenInput(users_index_url+'.json',
    theme: 'facebook',
#    theme: 'mac,'
    resultsLimit: 5,
    preventDuplicates: true,
    noResultsText: "No such User found.",
    minChars: 2,
    tokenDelimiter: ";",
    prePopulate: $('input#mail_to_users').data('load')
  )

  $("div>textarea#mail_body").keyup ->
    this.value = this.value.substr(0,254) if this.value.length > 254
    $("div#mail_body_counts").text(254 - this.value.length)

  $("input#clear").click ->
    $("div#mail_body_counts").text("254")

