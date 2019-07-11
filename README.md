# Motion Capture

This application uses motion capturing techniques using the [processing graphical library](https://processing.org/) to extract the movements of an object in a video and embed them into a new video.

The source video is a marionette monkey with red markers on its chest and extremities. These are tracked and extracted to use as motion signals to create an animation in the output video.

The animation is the character [Bender](https://en.wikipedia.org/wiki/Bender_(Futurama))  from the TV show [Futurama](https://en.wikipedia.org/wiki/Futurama). The background is a setting from the show, and some of the items from the show have been added as obstacles that interact with the animation.

All obstacles are randomly generated and can be placed in the foreground or background. Obstacles in the background can crash into each other, while obstacles in the foreground can crash into Bender or teleport through him. If bender destroys an obstacle he will play a catchphrase from the show.

## Requirements

1. [Processing Video Library](https://processing.org/reference/libraries/video/)
2. [Processing Sound Library](https://processing.org/reference/libraries/sound/)

Note: a [bug](https://github.com/processing/processing-sound/issues/39) in the sound library is causing Bender to only play a single catchphrase. Once the bug is fixed, he will say more.

## Demo

<iframe width="560" height="315" src="https://www.youtube.com/embed/uPc_oYV3cr8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>