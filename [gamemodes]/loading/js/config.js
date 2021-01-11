var config =
{    
    /*
        Do we want to show the image?
        Note that imageSize still affects the size of the image and where the progressbars are located.
    */
    enableImage: true,
 
    /*
        Relative path the the logo we want to display.
    */
    image: "img/logo.png",

    /*
        Cursor image
    */
    cursorImage: "img/cursor.png",
 
    /*
        How big should the logo be?
        The values are: [width, height].
        Recommended to use square images less than 1024px.
    */
    imageSize: [512, 512],
 
    /*
        Define the progressbar type
            0 = Single progressbar
            1 = Multiple progressbars
            2 = Collapsed progressbars
     */
    progressBarType: 0,
 
    /*
        Here you can disable some of progressbars.
        Only applys if `singleProgressbar` is false.
    */
    progressBars:
    {
        "INIT_CORE": {
            enabled: false, //NOTE: Disabled because INIT_CORE seems to not get called properly. (race condition).
        },
 
        "INIT_BEFORE_MAP_LOADED": {
            enabled: true,
        },
 
        "MAP": {
            enabled: true,
        },
 
        "INIT_AFTER_MAP_LOADED": {
            enabled: true,
        },
 
        "INIT_SESSION": {
            enabled: true,
        }
    },
 
    /*
        Loading messages will be randomly picked from the array.
        The message is located on the left side above the progressbar.
        The text will slowly fade in and out, each time with another message.
        You can use UTF-8 emoticons inside loading messages!
    */
    loadingMessages:
    [
        "Picking up snails... &#x1f40c;",
        "Placing snails on the map... &#x1f40c;",
        "Crushing a snail.... &#x1f40c; &#x1f528;",
        "Stepping on a snail.... &#x1f40c; &#x1f462;",
        "Putting slugs back into their shell.. &#x1f41a.",
        "Playing cricket with a snail... &#x1f3cf",
        "Programming snail AI... &#x1f9e0;",
        "Selling snails to a french guy. &#x1f956;",
        "Eating FiveM's mascot snail... &#x1f374;",
        "Syntasu is snailsome! &#x1f60d;",
        "Oof!",
        "Teaching a snail to drive... &#x1f697;",
        "Golfing using a snail... &#x1f3cc;",
        "Calling PETA for animal abuse... &#x1f4f1;",
        "No snails were hurt during this loadscreen. &#x1f691;",
    ],
 
    /*
        Rotate the loading message every 5000 milliseconds (default value).
    */
    loadingMessageSpeed: 5 * 1000,
 
    /*
        Array of music id's to play in the loadscreen.
        Enter your youtube video id's here. In order to obtain the video ID
        Take whats after the watch?v= on a youtube link.
        https://www.youtube.com/watch?v=<videoid>
        Do not include the playlist id or anything, it should be a 11 digit code.
       
        Do not use videos that:
            - Do not allow embedding.
            - Copyrighted music (youtube actively blocks this).
    */
    music:
    [
        "E9YhY3RYk_o",
    ],
 
 
    /*
        Set to false if you do not want any music.
    */
    enableMusic: true,
 
    /*
        Default volume for the player. Please keep this under 50%, to not blowout someones eardrums x)
     */
    musicVolume: 20,
 
    /*
        Should the background change images?
        True: it will not change backgrounds.
        False: it will change backgrounds.
    */
    staticBackground: false,
   
    /*
        Array of images you'd like to display as the background.
        Provide a path to a local image, using images via url is not recommended.
    */
    background:
    [
        "https://cdn.discordapp.com/attachments/334347603481198602/796907231227936778/unknown.png",
        "https://cdn.discordapp.com/attachments/334347603481198602/796824388217077830/Grand_Theft_Auto_V_Screenshot_2021.01.08_-_00.38.10.69.png",
        "https://cdn.discordapp.com/attachments/334347603481198602/796789977949667359/218_20210108040323_1.png",
        "https://cdn.discordapp.com/attachments/334347603481198602/796773039986442240/GTA5_2021-01-06_21-57-48.png",
        "https://cdn.discordapp.com/attachments/334347603481198602/796721629539467305/tezza2.png",
        "https://cdn.discordapp.com/attachments/334347603481198602/796718443515871272/Pic_20210107_131459_3840x2160.png",
        "https://cdn.discordapp.com/attachments/334347603481198602/796709525604401192/chaser2.png",
        "https://cdn.discordapp.com/attachments/334347603481198602/796630341866881054/image0.png",
        "https://cdn.discordapp.com/attachments/334347603481198602/796346555883847701/Screenshot_nissan_skyline_r34_omori_factory_s1_shibuya_grid_6-0-121-20-53-59.png",

    ],
 
    /*
        Time in milliseconds on how fast the background
        should swap images.
     */
    backgroundSpeed: 10 * 1000,

    /*
        Which style of animation should the background transition be?
        zoom = background zooms in and out.
        slide = transtion backgrounds from sliding right and back again.
        fade = fade the background out and back in.
    */
    backgroundStyle: "zoom",

    /*
        An on-screen logger, for indicating breaking bugs! :(
        Should we enable the on-screen logger? Handy for debugging or indicating errornous behaviour!
    */
    enableLog: true,
}
