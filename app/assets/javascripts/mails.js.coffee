
jQuery ->

  l = window.location
  users_index_url = '/' + l.pathname.split('/')[1]+'/users'
  
  $('input#mail_to_users').tokenInput(users_index_url+'.json?mod=mail',
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

