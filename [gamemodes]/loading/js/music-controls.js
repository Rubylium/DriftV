/*
    DOM elements....
*/
var container = document.getElementById("music-info");
var slider = document.getElementById("volumeSlider");
var np = document.getElementById("now-playing");
var playButton = document.getElementById("play-button")
/* 
    Setup the audio controls and create interval for music info updates.
*/

if(config.enableMusic)
{
    InitControls();
    setInterval(UpdateMusicInfo, 1000);
}
else
{
    container.style.display = "none";
}

/* 
    Initalize controls for music.
*/
function InitControls()
{
    slider.setAttribute("value", config.musicVolume);
    slider.addEventListener("input", UpdateVolume, false);
}

/* 
    Update the volume of the player.
*/
function UpdateVolume()
{
    setVolume((slider.value-1));
}


/* 
    Update the music info.
*/
function UpdateMusicInfo()
{

    if(title.length != 0)
    {
        np.innerHTML = "Now playing: " + title;
    }
    else
    {
        np.innerHTML = "Now playing: n.a.";
    }
}

var playing = true;


/* 
    Process the events from the start/stop button.
 */
function OnPlayClick()
{
    if(playing)
    {
        playing = false;
        pause();

        playButton.classList.remove("icon-pause2")
        playButton.classList.add("icon-play3")
        
    }
    else
    {
        playing = true;
        resume();

        playButton.classList.remove("icon-play3")
        playButton.classList.add("icon-pause2")
    }
}

function OnSkipClick()
{
    if(playing)
    {
        skip();
    }
}


/*
    Move cursor around.
*/
window.onload = function() 
{
  document.body.addEventListener("mousemove", function(event)
  {
        var cursor = document.getElementById("cursor");

        //TODO: More consistent way of aligning the cursor without awkward offsets?
        var x = event.pageX - cursor.width + 7;
        var y = event.pageY - 7;

        cursor.style.left = x;
        cursor.style.top = y;
  });
}