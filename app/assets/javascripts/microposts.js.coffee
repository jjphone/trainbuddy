jQuery ->
  $("#no-javascript").remove()

  textFilting = (input) ->
    input.replace(/[=|#]/g, "")

  updateForm = ->
    str = ""

    str = "#def=" + $("select#def-input").val() if $("select#def-input").val().length > 0

    str += $("input#loc-input").val()  if $("input#loc-input").val().length > 0
    if str.length < 4
      $("select#def-input").parent().addClass("label-important")
      $("input#loc-input").parent().addClass("label-important")
      return

    $("select#def-input").parent().removeClass("label-important")
    $("input#loc-input").parent().removeClass("label-important")

    str += $("input#time-input").val()  if $("input#time-input").val().length > 0
    str += "#subj=" + textFilting( $("input#subj-input").val() )  if $("input#subj-input").val().length > 0
    str += "#mate=" + $("input#mate-value").val() if $("input#mate-value").val().length > 0
    
    str = $("input#syd-input").val() + str
    $("input#content").val(str)
    $("div#select-post-count").text("Chars Left: " + (100 - str.length) )


  # syd 
  $("select#syd-type").change ->
    if @value is "act"
      $("input#syd-input").val("!tb#syd=act")
      $("span#syd-note").text("Recorded : Activity is logged and updates when matche is found")
    else
      $("input#syd-input").val("!tb#syd=ask")
      $("span#syd-note").text("Inquiry : no activity is recorded, no matching is search")
    updateForm()

  
  # text input changes 
  $("select#def-input, input#time-input, input#subj-input, input#mate-input").change ->
    updateForm()

  # loc 
  $("div#loc-fields>select").change ->
    str = ""
    $("div#loc-fields>select").each ->
      str += $(this).children("option:selected").val()

    if str.indexOf("2", 1) > 0
      $("input#loc-input").val("#loc=" + str.substring(1) )
    else
      $("input#loc-input").val(null)
    updateForm()

  
  # time 
  $("select#time-type").change ->
    if @value is "="
      $("input#time-value1").val(null)
      $("span#time-add").css("display", "none")
      $("span#time-exact").css("display", "inline")
    else
      $("input#time-value2").val(null)
      $("input#time-value3").val(null)
      $("span#time-exact").css("display", "none")
      $("span#time-add").css("display", "inline")

  $("span>input#time-value1").change ->
    str = @value.match(/\d{1,2}/)
    @value = str
    if str
      $("input#time-input").val("#time=+" + str)
      updateForm()

  $("span#time-exact>input").change ->
    # var hh = $("input#time-value2").val();
    hh = $("input#time-value2").val().match(/2[0-4]|1\d|0\d|\d/)
    mm = $("input#time-value3").val().match(/[0-5]\d/)
    mm = "00"  unless mm
    $("input#time-value3").val(mm)
    if hh
      $("input#time-value2").val(hh)
      $("input#time-input").val("#time=" + hh + ":" + mm)
      updateForm()
    else
      $("input#time-value2").val(null)
      $("input#time-input").val(null)



  l = window.location
  users_index_url = l.protocol + '//' + l.host + '/' + l.pathname.split('/')[1]+'/users'
  # users_index_url = l.protocol + '//' + l.host +'/users'
  
  $('input#mate-value').tokenInput(users_index_url+'.json?mod=mate',
    theme: 'facebook',
#    theme: 'mac,'
    resultsLimit: 5,
    preventDuplicates: true,
    noResultsText: "No such User found.",
    minChars: 2,
    tokenDelimiter: "",
    onAdd: (item) -> updateForm() ,
    onDelete: (item) -> updateForm()
  )
