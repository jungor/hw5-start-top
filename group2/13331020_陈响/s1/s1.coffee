$ ->
  $('.button').click -> diable_other_button(this)
  $("#bottom-positioner").mouseenter -> resert_all()

diable_other_button = (button) ->
  if $(button).attr("clicked") is "true"
    return
  buttons = $(button).siblings("li")
  for i in buttons
    $(i).attr("clicked", "true")
    $(i).css("background-color":"grey")
  show_button(button)

show_button = (button) ->
  console.log $(button)
  $(button).children(".unread").css("visibility":"visible")
  $.ajax '/',  
    type: 'GET'  
    dataType: 'html'  
    error: (jqXHR, textStatus, errorThrown) ->  
        console.log "ajax wrong"
    success: (data, textStatus, jqXHR) ->  
        $(button).children(".unread").html("#{data}")
        $(button).css("background-color":"grey")
        enable_other_button(button)

enable_other_button = (button) ->
  buttons = $(button).siblings("li")
  for i in buttons
    if $(i).children(".unread").html() is "..."
      $(i).css("background-color":"rgba(48,63,159,1)")
      $(i).attr("clicked", "false")
  $(button).attr("clicked", "true")
  get_sum(button)
  
get_sum = (button) ->
  sum = 0
  count = 1
  buttons = $(button).siblings("li")
  sum += parseInt($(button).children(".unread").html())
  for i in buttons
    if $(i).children(".unread").html() isnt "..."
      sum += parseInt($(i).children(".unread").html())
      count++
  if count is 5
    $("#info-bar").css("background-color":"rgba(48,63,159,1)")
    $("#info-bar").click -> 
      $(".sum").text(sum)
      $("#info-bar").css("background-color":"grey")


resert_all = () ->
  buttons = $(".button")
  $(".sum").text("")
  for i in buttons
    $(i).attr("clicked", "false")
    $(i).children(".unread").html("...")
    $(i).children(".unread").css("visibility":"hidden")
    $(i).css("background-color":"rgba(48,63,159,1)")