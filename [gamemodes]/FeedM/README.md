# FeedM
Customisable native feed notifications for FiveM

## Features
* Uses native UI
* Designed to emulate the native GTA:O feed system
* Can be positioned anywhere on screen unlike the native GTA:O notifications
* Customisable colors, fonts, etc
* Standard and advanced notifications
* Animated stacking and fading
* Supports reverse stacking for positioning at top of screen
* Supports message formatting
* Supports queuing and filtering duplicate notifications

## Contents

* [Demos](#demo-videos)
* [Requirements](#requirements)
* [Download & Installation](#download--installation)
* [Configuration](#configuration)
* [Events](#events)
    * [Trigger notification from client](#trigger-notification-from-client)
    * [Trigger notification from server](#trigger-notification-from-server)
    * [Trigger advanced notification from client](#trigger-advanced-notification-from-client)
    * [Trigger advanced notification from server](#trigger-advanced-notification-from-server)
* [Client Functions](#client-functions)
    * [Show notification](#show-notification)
    * [Show advanced notification](#show-advanced-notification)
* [Positioning](#positioning)
* [Custom Positions](#custom-positions)
* [ESX Users](#esx-users)

## Demo Videos

* [Standard](https://streamable.com/05s12l)
* [Bottom-Right Positioned](https://streamable.com/kxx4gq)
* [Top-Right Positioned](https://streamable.com/6b8rgs)
* [Queued](https://streamable.com/idwk31)
* [No animation](https://streamable.com/fx1zmd)

## Requirements

* None


## Download & Installation

* Download and extract the package: https://github.com/Mobius1/FeedM/archive/master.zip
* Rename the `FeedM-master` directory to `FeedM`
* Drop the `FeedM` directory into your `resources` directory on your server
* Add `start FeedM` in your `server.cfg`
* Edit `config.lua` to your liking
* Start your server and rejoice!

## Configuration

The `config.lua` file is set to emulate GTA:O as close as possible, but can be changed to fit your own needs.

```lua
Config.Enabled = true               -- Enable / disable
Config.Font = 4                     -- Font family
Config.Scale = 0.38                 -- Font size
Config.Width = 0.145                -- Box width
Config.Padding = 0.006              -- Box padding
Config.Spacing = 0.005              -- Box margin / seperation
Config.Queue = 5                    -- Message queue
Config.Position = "bottomLeft"      -- Position
Config.Animation = true             -- Toggle animation (fade out, stacking, etc)
Config.FilterDuplicates = true      -- Filter out duplicate notifications
```

## Events

#### Trigger notification from client
```lua
TriggerEvent("FeedM:showNotification", Message, Interval, Type)
```

#### Trigger notification from server
```lua
TriggerClientEvent("FeedM:showNotification", source, Message, Interval, Type)
```

#### Trigger advanced notification from client
```lua
TriggerEvent("FeedM:showAdvancedNotification", Title, Subject, Message, Icon, Interval, Type)
```

#### Trigger advanced notification from server
```lua
TriggerClientEvent("FeedM:showAdvancedNotification", source, Title, Subject, Message, Icon, Interval, Type)
```

Available params
* `Message` - the main message text you want to display
* `Interval` - The duration in `ms` you want the notification to be displayed
* `Type` - Determines the bg color of the message box (`primary`, `success`, `warning`, `danger`)
* `Title` - The title of the notification (advanced only)
* `Subject` - The subject of the notification (advanced only)
* `Icon` - The icon to be used (advanced only). A list of available icons can be found [here](https://wiki.gtanet.work/index.php?title=Notification_Pictures).

## Client Functions

#### Show notification
```lua
exports.FeedM:ShowNotification(Message, Interval, Type)
```

#### Show advanced notification
```lua
exports.FeedM:ShowAdvancedNotification(Title, Subject, Message, Icon, Interval, Type)
```

## Positioning

`FeedM` comes with popular positions already added, but should you need to define a custom position you can either edit the current ones or add a new one to the `Config.Positions` table in `config.lua`.

Positions below vertical center or keys containing the word `bottom` will cause messages to stack upward (old messages will be pushed upwards) and those above vertical center or keys containing the word `top` will cause messages to stack downwards (old messages will be pushed downwards).

```lua
Config.Positions = {
    bottomLeft  = { x = 0.085,  y = 0.70 },
    bottomRight = { x = 0.92,   y = 0.98 },
    topLeft     = { x = 0.085,  y = 0.02 },
    topRight    = { x = 0.92,   y = 0.02 }
}
```

**NOTE: Positioning is relative to the bottom-center of the message box so setting `x = 0.5` will align the center of the box to the horizontal center of the screen and setting `y = 0.5` will position the bottom of the box with the vertical center of the screen.**

#### ![Demo Image 1](https://i.imgur.com/1Kfqnqz.png)

## Custom Positions

To add your own custom position, just add a new entry to the `Config.Positions` table in `config.lua`:

```lua
Config.Positions = {
    ...
    myCustomPosition = {
        x = 0.5,
        y = 0.98
    }
}
```

Now tell `FeedM` to use your custom position:

```lua
Config.Position = "myCustomPosition"
```

Result

#### ![Demo Image 2](https://i.imgur.com/pOqI6mJ.png)

## ESX Users

You can override `es_extended` to use `FeedM` notifications by editing `es_extended/client/functions.lua` and adding the `exports` functions:

```lua
ESX.ShowNotification = function(msg)
    exports.FeedM:ShowNotification(msg)
end

ESX.ShowAdvancedNotification = function(title, subject, msg, icon, iconType)
    exports.FeedM:ShowAdvancedNotification(title, subject, msg, icon)
end
```

## To Do
- [x] ~~Support queuing~~
- [x] ~~Support duplicate notifications~~
- [x] ~~Remove ESX dependency~~
- [ ] Allow saving to `Info > Notifications` tab
- [ ] Allow notification sound
- [x] ~~Allow top-bottom stacking~~
- [ ] Allow overflow of large messages into another notification box

## Contributing
Pull requests welcome.

## Legal

### License

FeedM - Customisable native feed notifications for FiveM

Copyright (C) 2020 Karl Saunders

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.
