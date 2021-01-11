var lib = 
{
    rand: function(min, max)
    {
        return min + Math.floor(Math.random()*max);
    },

    fadeInOut: function(duration, elementId, min, max)
    {
        var halfDuration = duration / 2;

        setTimeout(function()  
        {
            var element = document.getElementById(elementId);
            element.style.opacity = min;

            setTimeout(function()  
            {
                element.style.opacity = max;

            }, halfDuration);  

        }, halfDuration);
    },
}
