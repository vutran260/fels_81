var interval;
function set_time(seconds, minutes){
  $("#minutes").html(minutes);
  $("#seconds").html(seconds);
}

function time_remain(total_in_seconds){
  if (total_in_seconds < 0){
    $("[type='submit']").remove();
    set_time(0,0);
  } else if (total_in_seconds == 0){
    $("form").submit();
    set_time(0,0);
  } else {
    minutes = Math.floor(total_in_seconds / 60);
    seconds = total_in_seconds % 60;
    set_time(seconds, minutes);
  }
  return;
}

var ready_var = function() {
  total_time_remain = $("#time-remain").data("time-remain");
  time_remain(total_time_remain);
  clearInterval(interval);
  interval = setInterval(function() {
    time_remain(total_time_remain--)
  }, 1000);
}

$(document).ready(ready_var);
$(document).on("page:load", ready_var);
