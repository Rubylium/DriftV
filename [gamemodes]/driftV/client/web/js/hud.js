function betterNumber(x) {
  return x.toLocaleString("fr-FR");
}

var lastPoints = 0;
var lastMulti = "x0.0"



$(function () {
  var audio = null

  window.addEventListener("message", function (event) {
    var item = event.data;


    if (item.ShowHud) {
      // Drift points
      $(".driftDisplay").html(betterNumber(item.driftPoints));
      $(".driftDisplayMulti").html(item.driftDisplayMulti)


      lastPoints = item.driftPoints
      lastMulti = item.driftDisplayMulti

      $("#container").fadeIn(500);
    } else if (item.HideHud) {
      // Hide GUI
      $(".driftImage").html('<img class="animate__animated animate__hinge driftImage" src="images/drifting.png" />');
      $(".driftDisplay").html('<div class="animate__animated animate__hinge driftDisplay"><span> ' + lastPoints +'</span></div>');
      $(".driftDisplayMulti").html('<div class="animate__animated animate__hinge driftDisplayMulti"><span> ' + lastMulti + '</span></div> ');
      $("#container").fadeOut(1000);
    }

    if (item.ShowSucces) { 
      $("#containerSucces").fadeIn(100);
      $(".succesText").html(item.label);
    } else if (item.HideSucces) {
      $("#containerSucces").fadeOut(500);
    }

    if (item.containerJoins) {

      console.log("Starting music " + url);
      audio = new Audio(url);
      audio.style.display = "none";
      audio.src = url;
      audio.autoplay = true;
      audio.volume = 0.1;


      $("#containerJoin").fadeIn(0);

    } 

    if (item.joinClick) {
      $("#containerJoin").fadeOut(500);
      var fadeOut = setInterval(function(){
        var newVolum = audio.volume - 0.01;
        if(newVolum <= 0.0){
          audio.remove()
          clearInterval(fadeOut);
        } else {
          audio.volume = newVolum;
        }
      }, 500);
    }


  });

  $('.clickJoinButton').on('click', function (e) {
		e.preventDefault();
		$.post('https://driftv/joinServer', JSON.stringify(test = false));
	});
});