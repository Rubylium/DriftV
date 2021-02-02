$(document).ready(function(){

  window.addEventListener("message", function(event){
    // Show HUD when player enter a vehicle
    if(event.data.showhud == true){
      $('.huds').fadeIn();
      setProgressSpeed(0,'.progress-speed');
    }
    if(event.data.showhud == false){
      $('.huds').fadeOut();
    }

    if(event.data.setAngle == true){
      setProgressSpeed(event.data.angle,'.progress-speed');
    }

  });

  // Speed
  function setProgressSpeed(value, element){
    var circle = document.querySelector(element);
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;
    var html = $(element).parent().parent().find('span');
    var percent = value*100/45;

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent*73)/100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    html.text(value);
  }

  // setProgress(input.value,element);
  // setProgressFuel(85,'.progress-fuel');
  // setProgressSpeed(124,'.progress-speed');

});
