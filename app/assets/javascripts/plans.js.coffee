jQuery ->

#  time
  time_type = (tt) ->
    if tt is "+"
      $("input#time-value2").val null
      $("input#time-value3").val null
      $("span#time-exact").css "display", "none"
      $("span#time-add").css "display", "inline"
    else
      $("input#time-value1").val null
      $("span#time-add").css "display", "none"
      $("span#time-exact").css "display", "inline"

  

  time_type $("select#time-type").val()

  $("select#time-type").change ->
    time_type $("select#time-type").val()

  $("span>input#time-value1").change ->
    str = @value.match(/\d{1,2}/)
    @value = str
    $("input#plan_time").val "+" + str  if str

  

  $("span#time-exact>input").change ->    
    # var hh = $("input#time-value2").val();
    hh = $("input#time-value2").val().match(/2[0-4]|1\d|0\d|\d/)
    mm = $("input#time-value3").val().match(/[0-5]\d/)
    mm = "00"  unless mm
    $("input#time-value3").val mm
    if hh
      $("input#time-value2").val hh
      $("input#plan_time").val hh + ":" + mm
    else
      $("input#time-value2").val null
      $("input#plan_time").val null

  
# loc 
  $("div#loc-fields>select").change ->
    str = ""
    $("div#loc-fields>select").each ->
      str += $(this).children("option:selected").val()

    if str.indexOf("2", 1) > 0
      $("input#plan_loc").val str.substring(1)
    else
      $("input#plan_loc").val null


