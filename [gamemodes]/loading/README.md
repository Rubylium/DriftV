# Synn's Loading Screen

A simple loading screen resource for FiveM.

<hr>

## Features

- Progressbar  
    - Can have multiple progress bars for each type.
    - Can have single progress bars for all types
- Loading screen image
- Rotating loading messages
- Music player
    - Play videos directly from youtube.
    - Pause and unpause and control volume on the fly.
- Backgrounds
    - Rotating backgrounds with fade in and fade out.
- All of the above can be edited in the config.

<hr>

## Planned
 
### Version 2 is planned (see issues)
- Improve general robustness
- Aiming for ease of use
- Allowing greater flexibility when it comes to customizing
- Some frequently requested features
- General improvements.

<hr>

## Example

![Loading screen example](docs/single.png "Example of single progressbar")
![Loading screen example](docs/multi.png "Example of multiple progressbars")
![Loading screen example](docs/collapse.png "Example of collapsed progressbars")


<hr>

## Installing

1) Download the files from the repository (or see [releases](https://github.com/Syntasu/synn-loadscreen/releases))

2) Create a folder in your resources folder named "synn-loadscreen"

3) Add the files into the newly create folder in the resources.

4) Add "start synn-loadscreen" to your server.cfg

And you are good to go!

<hr>

## Known issues

[Issue 1](https://github.com/Syntasu/synn-loadscreen/issues/1)
Race condition between my loadscreen resource and the events that need to get passed to the loadscreen.
Implications are that some loadbars do not fill and upon connecting nothing happens.

[Issue 10](https://github.com/Syntasu/synn-loadscreen/issues/10)
It seems some people are affected by a bug which bugs out the loadingscreen.
<hr>

## Contributing

Feel free to make any pull request, if you believe it is an improvement to the current state.

Feature requests and/or enhancements can be posted into the issues.

<hr>

## License

This project falls under the GNU GPLv2 license. (see LICENSE)

<hr>

## Modification and distribution

If you intend to modify this resource:
- Have a reference back to this GitHub repository
- The source must be publicly available (as stated in GPL 2.0)
- State the changes you made.
- Include the same license (GNU GPL 2.0) (See LICENSE)

If you intend to distibute
- Have a reference back to this GitHub repository or FiveM topic.

<hr>

## Sources and acknowledgements
The follow source(s) were used to create this resource. This might be useful for further research.

* [Loading Screen guide by Denziel0495](https://forum.fivem.net/t/how-to-custom-loading-screen-with-music/5746)
* [Default loading screen of FiveM](https://github.com/citizenfx/fivem/blob/fde2bb3120cb1bc7a3ecfc31c3ff103896bd0b12/ext/ui-build/data/loadscreen/code.js)
* [TheStonedTurtle's implementation](https://github.com/TheStonedTurtle/FiveM-PercentLoadScreen)
* The lovely people in the [FiveM discord](https://discord.gg/GtvkUsc) for lending a hand.

<hr>

## Contact

Feel free to contact me about issues, feature request or questions. (anything really!)

If you wish to contact me:

- Via my own discord, [here](https://discord.gg/qXtJc9s) or directly: `Syntasu#8763`.
- Via the [FiveM forums](https://forum.fivem.net/u/syntasu)
