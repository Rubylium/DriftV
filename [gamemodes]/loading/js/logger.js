var logger = 
{
    logListSize: 10,
    logList: document.getElementById("log"),
    logEntries: [],

    init: function()
    {
        for(i = 0; i < logger.logListSize; i++)
        {
            var node = document.createElement("li");
            logger.logList.appendChild(node)
        }
    },

    addToLog: function(message)
    {
        if(!config.enableLog) return;

        logger.logEntries.push(message); 

        if(logger.logEntries.length > logger.logListSize)
        {
            logger.logEntries.shift();
        }

        logger.render();
    },

    render: function()
    {
        if(!config.enableLog) return;

        for(i = 0; i < logger.logListSize; i++)
        {
            var entry = logger.logEntries[i];

            if(entry === undefined)
            {
                continue;
            }

            logger.logList.childNodes[i].innerHTML = entry;
        }
    },
}

logger.init();