Init();

//Cache to keep track of all progress values.
//This is need for the Math.max functions (so no backwards progressbars).
var progressCache = [];

function Init()
{
    //TODO: This does not belong in here...
    var logo = document.getElementById("logo");

    if(config.enableImage)
    {
        logo.setAttribute("src", config.image);
        logo.setAttribute("width", config.imageSize[0]);
        logo.setAttribute("height", config.imageSize[1]);
    }
    else
    {
        logo.setAttribute("src", config.image);
        logo.setAttribute("width", config.imageSize[0]);
        logo.style.visibility = "hidden";
    }


    var cursor = document.getElementById("cursor");
    cursor.setAttribute("src", config.cursorImage);


    if(config.progressBarType == 0)
    {
        //Start single progressbar.
        var progressBar = document.getElementById("pb0");
        progressBar.classList.remove("hide");

        setInterval(UpdateSingle, 250);
    }
    else
    {
        //Show the progressbars we need.
        for(i = 0; i < 5; i++)
        {
            if(config.progressBars[types[i]].enabled)
            {
                var progressBar = document.getElementById("pb" + i);
                progressBar.classList.remove("hide");

                if(config.progressBarType == 2)
                {
                    progressBar.classList.add("pbCollapse");
                }
            }
        }

        //Start updating.
        setInterval(UpdateMulti, 250);
    }

    //Start with random message.
    var message = document.getElementById("message");
    var index = lib.rand(0, config.loadingMessages.length);
    message.innerHTML = config.loadingMessages[index];

    //Account for transition time (about ~400ms).
    setInterval(RotateMessage, (config.loadingMessageSpeed + 400));
}

function UpdateMulti()
{
    UpdateTotalProgress();

    //Set individual loading bars:
    for(i = 0; i < types.length; i++)
    {
        var progress =  GetTypeProgress(types[i]);
        var progressBar = document.getElementById("pb" + i);
        
        if(progressCache[i] != null)
        {
            progress = Math.max(progress, progressCache[i]);
        }

        if(isNaN(progress))
        {
            progress = 0;
            console.log("Woops!")
        }

        progressBar.value = progress;
        progressCache[i] = progress;
    }
}    

//Update the single progressbar.
function UpdateSingle()
{
    UpdateTotalProgress();

    var progressBar = document.getElementById("pb0");
    progressBar.value = progressCache[10];

}

// Update the total percentage loaded (above the progressbar on the right).
function UpdateTotalProgress()
{
        //Set the total progress counter:
        var total = GetTotalProgress();
        var totalProgress = document.getElementById("progress-bar-value");
    
        if(progressCache[10] != null)
        {
            total = Math.max(total, progressCache[10]);
        }
        
        totalProgress.innerHTML = Math.round(total);
        progressCache[10] = total;
}

// Rotate message, load new message every x milliseconds.
function RotateMessage()
{
    lib.fadeInOut(600, "message", 0, 1);

    setTimeout(function()
    {
        var message = document.getElementById("message");
        var index = lib.rand(0, config.loadingMessages.length);      
        message.innerHTML = config.loadingMessages[index];
    }, 600);
}

