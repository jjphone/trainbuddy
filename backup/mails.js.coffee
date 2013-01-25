# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  l = window.location
  users_index_url = l.protocol + '//' + l.host + '/' + l.pathname.split('/')[1]+'/users'
  
  $('#mail_to_users').tokenInput(users_index_url+'.json',
    theme: 'facebook',
    resultsLimit: 5,
    preventDuplicates: true,
    noResultsText: "No such User found.",
    minChars: 2,
    tokenDelimiter: ";",
    prePopulate: $('#mail_to_users').data('load')
#     onResult: (result) -> $.each(result,
#       (index,value) -> 
#         value.id = value.id+"="+value.name
#         value.name = value.name + value.alias)
  )
