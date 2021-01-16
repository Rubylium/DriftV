var audio = null

function playSound(url){
    console.log("Starting music " + url);
    audio = new Audio(url);
    audio.style.display = "none";
    audio.src = url;
    audio.autoplay = true;
    audio.volume = 0.1;
}

function FadeOutMusic() {
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